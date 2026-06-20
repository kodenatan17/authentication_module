import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';

/// High-level auth service wrapping [AuthRepository].
class AuthService {
  final AuthRepository _repository;

  AuthService(this._repository);

  /// Login with phone + password.
  Future<AuthResult> login({
    required String phone,
    required String password,
  }) {
    return _repository.login(phone: phone, password: password);
  }

  /// Verify OTP after registration.
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  }) {
    return _repository.verifyOtp(phone: phone, otp: otp);
  }

  /// Whether user is currently authenticated.
  bool get isAuthenticated => _repository.isAuthenticated;

  /// Current access token, or null.
  String? get token => _repository.token;

  /// Logout — clear stored credentials.
  Future<void> logout() => _repository.logout();
}
