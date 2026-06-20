import 'package:equatable/equatable.dart';
import 'auth_user.dart';

/// Result returned by auth endpoints.
class AuthResult extends Equatable {
  final bool success;
  final String token;
  final AuthUser user;

  const AuthResult({
    required this.success,
    required this.token,
    required this.user,
  });

  AuthResult copyWith({
    bool? success,
    String? token,
    AuthUser? user,
  }) {
    return AuthResult(
      success: success ?? this.success,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [success, token, user];
}
