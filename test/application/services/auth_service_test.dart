import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:authentication_module/application/services/auth_service.dart';
import 'package:authentication_module/domain/entities/auth_result.dart';
import 'package:authentication_module/domain/entities/auth_user.dart';
import 'package:authentication_module/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late AuthService authService;

  setUp(() {
    mockRepo = MockAuthRepository();
    authService = AuthService(mockRepo);
  });

  group('login', () {
    const phone = '08123456789';
    const password = 'secret123';
    final result = AuthResult(
      success: true,
      token: 'token-abc',
      user: const AuthUser(id: 1, name: 'John', phone: phone),
    );

    test('delegates to repository', () async {
      when(() => mockRepo.login(phone: phone, password: password))
          .thenAnswer((_) async => result);

      final res = await authService.login(phone: phone, password: password);

      expect(res, result);
      verify(() => mockRepo.login(phone: phone, password: password)).called(1);
    });

    test('propagates repository error', () async {
      when(() => mockRepo.login(phone: phone, password: password))
          .thenThrow(Exception('Network error'));

      expect(
        () => authService.login(phone: phone, password: password),
        throwsException,
      );
    });
  });

  group('verifyOtp', () {
    const phone = '08123456789';
    const otp = '123456';
    final result = AuthResult(
      success: true,
      token: 'token-xyz',
      user: const AuthUser(id: 1, name: 'John', phone: phone),
    );

    test('delegates to repository', () async {
      when(() => mockRepo.verifyOtp(phone: phone, otp: otp))
          .thenAnswer((_) async => result);

      final res = await authService.verifyOtp(phone: phone, otp: otp);

      expect(res, result);
      verify(() => mockRepo.verifyOtp(phone: phone, otp: otp)).called(1);
    });

    test('propagates repository error', () async {
      when(() => mockRepo.verifyOtp(phone: phone, otp: otp))
          .thenThrow(Exception('Timeout'));

      expect(
        () => authService.verifyOtp(phone: phone, otp: otp),
        throwsException,
      );
    });
  });

  group('isAuthenticated', () {
    test('delegates to repository', () {
      when(() => mockRepo.isAuthenticated).thenReturn(true);
      expect(authService.isAuthenticated, true);

      when(() => mockRepo.isAuthenticated).thenReturn(false);
      expect(authService.isAuthenticated, false);
    });
  });

  group('token', () {
    test('returns token from repository', () {
      when(() => mockRepo.token).thenReturn('some-token');
      expect(authService.token, 'some-token');
    });

    test('returns null when no token', () {
      when(() => mockRepo.token).thenReturn(null);
      expect(authService.token, null);
    });
  });

  group('logout', () {
    test('delegates to repository', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async {});

      await authService.logout();

      verify(() => mockRepo.logout()).called(1);
    });
  });
}
