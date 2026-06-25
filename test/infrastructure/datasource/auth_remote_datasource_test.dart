import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:authentication_module/infrastructure/datasource/auth_remote_datasource.dart';
import 'package:authentication_module/infrastructure/models/auth_refresh_token_data_model.dart';
import 'package:authentication_module/infrastructure/models/auth_refresh_token_response.dart';
import 'package:authentication_module/infrastructure/models/user_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSource dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSource(mockDio);
  });

  group('login', () {
    const phone = '08123456789';
    const password = 'secret123';

    final responseJson = {
      'status': {'code': 200, 'message': 'OK'},
      'data': {
        'success': true,
        'token': 'token-abc',
        'user': {'id': 1, 'name': 'John', 'phone': '08123456789', 'avatar': ''},
      },
      'meta': null,
    };

    test('returns AuthRefreshTokenResponse on success', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/login',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: responseJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/login'),
          ));

      final result = await dataSource.login(phone: phone, password: password);

      expect(result, isA<AuthRefreshTokenResponse>());
      expect(result.data.success, true);
      expect(result.data.token, 'token-abc');
      expect(result.data.user.id, 1);
    });

    test('handles empty response data', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/login',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {
              'status': {'code': 200, 'message': 'OK'},
              'data': <String, dynamic>{},
              'meta': null,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/login'),
          ));

      final result = await dataSource.login(phone: phone, password: password);

      expect(result.data.success, false);
      expect(result.data.token, '');
      expect(result.data.user.id, 0);
    });

    test('throws on network error', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/login',
            data: any(named: 'data'),
          )).thenThrow(DioException(
            requestOptions: RequestOptions(path: '/auth/login'),
            error: 'Connection failed',
          ));

      expect(
        () => dataSource.login(phone: phone, password: password),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('verifyOtp', () {
    const phone = '08123456789';
    const otp = '123456';

    final responseJson = {
      'status': {'code': 200, 'message': 'OK'},
      'data': {
        'success': true,
        'token': 'token-xyz',
        'user': {'id': 1, 'name': 'John', 'phone': '08123456789', 'avatar': ''},
      },
      'meta': null,
    };

    test('returns AuthRefreshTokenResponse on success', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/register/verify',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: responseJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/register/verify'),
          ));

      final result = await dataSource.verifyOtp(phone: phone, otp: otp);

      expect(result, isA<AuthRefreshTokenResponse>());
      expect(result.data.success, true);
      expect(result.data.token, 'token-xyz');
    });

    test('throws on network error', () async {
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/register/verify',
            data: any(named: 'data'),
          )).thenThrow(DioException(
            requestOptions: RequestOptions(path: '/auth/register/verify'),
            error: 'Timeout',
          ));

      expect(
        () => dataSource.verifyOtp(phone: phone, otp: otp),
        throwsA(isA<DioException>()),
      );
    });
  });
}
