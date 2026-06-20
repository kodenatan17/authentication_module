import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/services/auth_service.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Business logic for login and OTP verification.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    if (_authService.isAuthenticated) {
      emit(const AuthAuthenticated(
        user: AuthUser(id: 0, name: '', phone: ''),
        token: '',
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await _authService.login(
        phone: event.phone,
        password: event.password,
      );
      if (result.success) {
        emit(AuthAuthenticated(user: result.user, token: result.token));
      } else {
        emit(AuthError(
          message: 'Login gagal. Periksa nomor HP dan password.',
          phone: event.phone,
        ));
      }
    } catch (e) {
      emit(AuthError(
        message: _errorMessage(e),
        phone: event.phone,
      ));
    }
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await _authService.verifyOtp(
        phone: event.phone,
        otp: event.otp,
      );
      if (result.success) {
        emit(AuthAuthenticated(user: result.user, token: result.token));
      } else {
        emit(AuthError(
          message: 'Verifikasi OTP gagal. Coba lagi.',
          phone: event.phone,
        ));
      }
    } catch (e) {
      emit(AuthError(
        message: _errorMessage(e),
        phone: event.phone,
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.logout();
    emit(const AuthUnauthenticated());
  }

  String _errorMessage(Object e) {
    if (e is Exception) {
      return 'Terjadi kesalahan. Coba lagi.';
    }
    return 'Terjadi kesalahan. Coba lagi.';
  }
}
