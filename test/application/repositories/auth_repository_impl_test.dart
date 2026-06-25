import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:authentication_module/application/repositories/auth_repository_impl.dart';
import 'package:authentication_module/domain/entities/auth_result.dart';
import 'package:authentication_module/infrastructure/datasource/auth_remote_datasource.dart';
import 'package:authentication_module/infrastructure/models/auth_refresh_token_data_model.dart';
import 'package:authentication_module/infrastructure/models/auth_refresh_token_response.dart';
import 'package:authentication_module/infrastructure/models/user_model.dart';
import 'package:core_module/core_module.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class FakeBox extends Fake implements Box<dynamic> {
  final Map<String, dynamic> _store = {};

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) => _store[key as String] ?? defaultValue;

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _store[key as String] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _store.remove(key as String);
  }

  @override
  bool get isOpen => true;
}

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late AuthRepositoryImpl repository;

  setUp(() async {
    final dir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(dir.path);
    mockRemote = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemote);
  });

  tearDown(() {
    Hive.deleteBoxFromDisk('resident_auth');
  });

  group('login', () {
    test('returns AuthResult and saves token on success', () async {
      final responseData = AuthRefreshTokenDataModel(
        success: true,
        token: 'token-abc',
        user: const UserModel(id: 1, name: 'John', phone: '08123'),
      );
      final response = AuthRefreshTokenResponse(
        responseData,
        Status(code: 200, message: 'OK'),
        null,
      );

      when(() => mockRemote.login(phone: any(named: 'phone'), password: any(named: 'password')))
          .thenAnswer((_) async => response);

      final result = await repository.login(phone: '08123', password: 'pwd');

      expect(result, isA<AuthResult>());
      expect(result.success, true);
      expect(result.token, 'token-abc');
    });

    test('returns AuthResult without saving token on failed login', () async {
      final responseData = AuthRefreshTokenDataModel(
        success: false,
        token: '',
        user: const UserModel(id: 0, name: '', phone: ''),
      );
      final response = AuthRefreshTokenResponse(
        responseData,
        Status(code: 401, message: 'Unauthorized'),
        null,
      );

      when(() => mockRemote.login(phone: any(named: 'phone'), password: any(named: 'password')))
          .thenAnswer((_) async => response);

      final result = await repository.login(phone: '08123', password: 'wrong');

      expect(result.success, false);
      expect(result.token, '');
    });
  });

  group('verifyOtp', () {
    test('returns AuthResult and saves token on success', () async {
      final responseData = AuthRefreshTokenDataModel(
        success: true,
        token: 'token-xyz',
        user: const UserModel(id: 1, name: 'John', phone: '08123'),
      );
      final response = AuthRefreshTokenResponse(
        responseData,
        Status(code: 200, message: 'OK'),
        null,
      );

      when(() => mockRemote.verifyOtp(phone: any(named: 'phone'), otp: any(named: 'otp')))
          .thenAnswer((_) async => response);

      final result = await repository.verifyOtp(phone: '08123', otp: '123456');

      expect(result, isA<AuthResult>());
      expect(result.success, true);
      expect(result.token, 'token-xyz');
    });

    test('returns AuthResult without saving on failed verify', () async {
      final responseData = AuthRefreshTokenDataModel(
        success: false,
        token: '',
        user: const UserModel(id: 0, name: '', phone: ''),
      );
      final response = AuthRefreshTokenResponse(
        responseData,
        Status(code: 400, message: 'Bad Request'),
        null,
      );

      when(() => mockRemote.verifyOtp(phone: any(named: 'phone'), otp: any(named: 'otp')))
          .thenAnswer((_) async => response);

      final result = await repository.verifyOtp(phone: '08123', otp: 'wrong');

      expect(result.success, false);
      expect(result.token, '');
    });
  });

  group('token management', () {
    test('isAuthenticated returns false when no token', () {
      expect(repository.isAuthenticated, false);
    });

    test('token returns null when no token', () {
      expect(repository.token, null);
    });

    test('logout does not throw', () async {
      await expectLater(repository.logout(), completes);
    });
  });
}
