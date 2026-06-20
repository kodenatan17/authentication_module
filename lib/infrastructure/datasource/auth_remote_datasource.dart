import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';

/// Remote data source for auth API calls.
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// POST /auth/login
  Future<AuthResponseModel> login({
    required String phone,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
    );
    return AuthResponseModel.fromJson(response.data ?? {});
  }

  /// POST /auth/register/verify
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/register/verify',
      data: {
        'phone': phone,
        'otp': otp,
      },
    );
    return AuthResponseModel.fromJson(response.data ?? {});
  }
}
