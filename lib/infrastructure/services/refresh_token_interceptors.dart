import 'package:authentication_module/infrastructure/datasource/auth_local_datasource.dart';
import 'package:authentication_module/infrastructure/models/request/auth_refresh_token_request_model.dart';
import 'package:authentication_module/infrastructure/services/auth_api_service.dart';
import 'package:authentication_module/injection/authentication_injection.dart';
import 'package:core_module/core_module.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class RefreshTokenInterceptor extends Interceptor {
  final DioForNative dio;

  RefreshTokenInterceptor(this.dio);

  /// Extract error message from various API response structures
  /// Supports:
  /// - { "status": { "message": "..." } }  (current API format)
  /// - { "message": "..." }                 (legacy format)
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      // Try nested status.message first (current API format)
      if (data['status'] is Map<String, dynamic>) {
        final status = data['status'] as Map<String, dynamic>;
        if (status['message'] is String) {
          return status['message'] as String;
        }
      }

      // Fallback to root level message
      if (data['message'] is String) {
        return data['message'] as String;
      }
    }

    return null;
  }

  /// Check if error message indicates token expiration
  bool _isTokenExpiredError(String? message) {
    if (message == null) return false;

    final lowerMessage = message.toLowerCase();
    return lowerMessage == 'unauthorized' ||
        lowerMessage == 'the token is expired' ||
        lowerMessage == 'invalid or expired token';
  }

  /// Check if this is the refresh token endpoint itself
  /// We must NOT attempt to refresh when the refresh-token endpoint fails
  bool _isRefreshTokenEndpoint(String? path) {
    if (path == null) return false;
    return path.contains('refresh-token');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // IMPORTANT: Skip refresh logic for the refresh-token endpoint itself
    // to prevent infinite loop when refresh token is also expired
    if (_isRefreshTokenEndpoint(err.requestOptions.path)) {
      debugPrint(
        '🔐 RefreshTokenInterceptor: Skipping - this is refresh-token endpoint',
      );
      return handler.next(err);
    }

    final AuthLocalDataSource authLocalDataSource =
        getIt<AuthLocalDataSource>();
    final AuthApiService authApiService = getIt<AuthApiService>();

    if (err.response != null) {
      final statusCode = err.response!.statusCode;

      if (statusCode == 400 || statusCode == 401) {
        final errorMessage = _extractErrorMessage(err.response?.data);

        debugPrint(
          '🔐 RefreshTokenInterceptor: Status $statusCode, message: $errorMessage',
        );

        if (_isTokenExpiredError(errorMessage)) {
          debugPrint(
            '🔐 RefreshTokenInterceptor: Token expired - attempting refresh',
          );

          try {
            final refreshToken = await authLocalDataSource.getRefreshToken();

            if (refreshToken.isEmpty) {
              debugPrint(
                '🔐 RefreshTokenInterceptor: No refresh token available',
              );
              return handler.reject(err);
            }

            debugPrint('🔐 RefreshTokenInterceptor: Calling refresh token API');

            final response = await authApiService.refreshToken(
              AuthRefreshTokenRequestModel(refreshToken: refreshToken),
            );

            debugPrint(
              '🔐 RefreshTokenInterceptor: Refresh successful, saving new tokens',
            );

            await authLocalDataSource.setToken(
              response.data.accessToken,
              response.data.refreshToken,
            );

            debugPrint('🔐 RefreshTokenInterceptor: Retrying original request');

            final retryResponse = await _retryRequest(err.requestOptions);
            return handler.resolve(retryResponse);
          } on CacheException catch (e) {
            debugPrint('🔐 RefreshTokenInterceptor: Cache error - $e');
            return handler.reject(err);
          } catch (e) {
            debugPrint('🔐 RefreshTokenInterceptor: Refresh failed - $e');
            return handler.reject(err);
          }
        }

        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    // Get fresh token for retry
    final authLocalDataSource = getIt<AuthLocalDataSource>();
    final newToken = await authLocalDataSource.getAccessToken();

    final requestOptions = Options(
      method: options.method,
      headers: {...options.headers, 'Authorization': 'Bearer $newToken'},
    );

    return dio.request<dynamic>(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: requestOptions,
    );
  }
}
