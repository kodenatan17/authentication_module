import 'dart:io';

import 'package:authentication_module/infrastructure/datasource/auth_local_datasource.dart';
import 'package:authentication_module/injection/authentication_injection.dart';
import 'package:dio/dio.dart';

class AuthorizationInterceptors extends Interceptor {
  bool isWhiteListPath(RequestOptions options) {
    return whiteListPath.contains(options.path);
  }

  static List<String> whiteListPath = [
    '/auth/request-otp',
    '/auth/submit-otp',
    '/auth/refresh-token',
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final AuthLocalDataSource authLocalDataSource =
        getIt<AuthLocalDataSource>();

    try {
      final isLoggedIn = await authLocalDataSource.isUserLoggedIn();
      if (!isWhiteListPath(options) && isLoggedIn) {
        final accessToken = await authLocalDataSource.getAccessToken();
        options.headers.addAll({"Authorization": "Bearer $accessToken"});
      }
      options.headers.addAll({
        "X-Device-Type": Platform.isIOS ? "IOS" : "ANDROID",
      });
      super.onRequest(options, handler);
    } catch (e) {
      super.onRequest(options, handler);
    }
  }
}
