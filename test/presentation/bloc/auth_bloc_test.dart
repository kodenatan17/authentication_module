import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:authentication_module/application/services/auth_service.dart';
import 'package:authentication_module/domain/entities/auth_result.dart';
import 'package:authentication_module/domain/entities/auth_user.dart';
import 'package:authentication_module/presentation/bloc/auth_bloc.dart';
import 'package:authentication_module/presentation/bloc/auth_event.dart';
import 'package:authentication_module/presentation/bloc/auth_state.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockService;
  late AuthBloc authBloc;

  setUp(() {
    mockService = MockAuthService();
    authBloc = AuthBloc(authService: mockService);
  });

  tearDown(() {
    authBloc.close();
  });

  group('CheckAuthStatus', () {
    test('emits [AuthAuthenticated] when authenticated', () async {
      when(() => mockService.isAuthenticated).thenReturn(true);

      final expected = [
        const AuthAuthenticated(
          user: AuthUser(id: 0, name: '', phone: ''),
          token: '',
        ),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(const CheckAuthStatus());
    });

    test('emits [AuthUnauthenticated] when not authenticated', () async {
      when(() => mockService.isAuthenticated).thenReturn(false);

      final expected = [const AuthUnauthenticated()];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(const CheckAuthStatus());
    });
  });

  group('LoginSubmitted', () {
    const phone = '08123456789';
    const password = 'secret123';

    test('emits [AuthLoading, AuthAuthenticated] on success', () async {
      final result = AuthResult(
        success: true,
        token: 'token-abc',
        user: const AuthUser(id: 1, name: 'John', phone: phone),
      );
      when(() => mockService.login(phone: phone, password: password))
          .thenAnswer((_) async => result);

      final expected = [
        const AuthLoading(),
        AuthAuthenticated(user: result.user, token: result.token),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(LoginSubmitted(phone: phone, password: password));
    });

    test('emits [AuthLoading, AuthError] on failed login', () async {
      final result = AuthResult(
        success: false,
        token: '',
        user: const AuthUser(id: 0, name: '', phone: ''),
      );
      when(() => mockService.login(phone: phone, password: password))
          .thenAnswer((_) async => result);

      final expected = [
        const AuthLoading(),
        AuthError(
          message: 'Login gagal. Periksa nomor HP dan password.',
          phone: phone,
        ),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(LoginSubmitted(phone: phone, password: password));
    });

    test('emits [AuthLoading, AuthError] on exception', () async {
      when(() => mockService.login(phone: phone, password: password))
          .thenThrow(Exception('error'));

      final expected = [
        const AuthLoading(),
        AuthError(message: 'Terjadi kesalahan. Coba lagi.', phone: phone),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(LoginSubmitted(phone: phone, password: password));
    });
  });

  group('VerifyOtpSubmitted', () {
    const phone = '08123456789';
    const otp = '123456';

    test('emits [AuthLoading, AuthAuthenticated] on success', () async {
      final result = AuthResult(
        success: true,
        token: 'token-xyz',
        user: const AuthUser(id: 1, name: 'John', phone: phone),
      );
      when(() => mockService.verifyOtp(phone: phone, otp: otp))
          .thenAnswer((_) async => result);

      final expected = [
        const AuthLoading(),
        AuthAuthenticated(user: result.user, token: result.token),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(VerifyOtpSubmitted(phone: phone, otp: otp));
    });

    test('emits [AuthLoading, AuthError] on failed OTP', () async {
      final result = AuthResult(
        success: false,
        token: '',
        user: const AuthUser(id: 0, name: '', phone: ''),
      );
      when(() => mockService.verifyOtp(phone: phone, otp: otp))
          .thenAnswer((_) async => result);

      final expected = [
        const AuthLoading(),
        AuthError(
          message: 'Verifikasi OTP gagal. Coba lagi.',
          phone: phone,
        ),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(VerifyOtpSubmitted(phone: phone, otp: otp));
    });

    test('emits [AuthLoading, AuthError] on exception', () async {
      when(() => mockService.verifyOtp(phone: phone, otp: otp))
          .thenThrow(Exception('timeout'));

      final expected = [
        const AuthLoading(),
        AuthError(message: 'Terjadi kesalahan. Coba lagi.', phone: phone),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(VerifyOtpSubmitted(phone: phone, otp: otp));
    });
  });

  group('LogoutRequested', () {
    test('emits [AuthUnauthenticated] after logout', () async {
      when(() => mockService.logout()).thenAnswer((_) async {});

      final expected = [const AuthUnauthenticated()];

      expectLater(authBloc.stream, emitsInOrder(expected));

      authBloc.add(const LogoutRequested());
    });
  });
}
