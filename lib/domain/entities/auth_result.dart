import 'auth_user.dart';

/// Result returned by auth endpoints.
class AuthResult {
  final bool success;
  final String token;
  final AuthUser user;

  const AuthResult({
    required this.success,
    required this.token,
    required this.user,
  });
}
