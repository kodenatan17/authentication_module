import '../entities/auth_result.dart';

/// Authentication repository contract.
abstract class AuthRepository {
  /// Login with phone + password.
  Future<AuthResult> login({required String phone, required String password});

  /// Verify OTP sent during registration.
  Future<AuthResult> verifyOtp({required String phone, required String otp});

  /// Check if user is currently authenticated.
  bool get isAuthenticated;

  /// Get stored token, or null if not logged in.
  String? get token;

  /// Clear auth state (logout).
  Future<void> logout();
}
