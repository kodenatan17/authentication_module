import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

/// JSON-serializable model matching AuthResponse from API contract.
class AuthResponseModel {
  final bool success;
  final String token;
  final UserModel user;

  const AuthResponseModel({
    required this.success,
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] as bool? ?? false,
      token: json['token'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'token': token,
        'user': user.toJson(),
      };

  AuthResult toEntity() => AuthResult(
        success: success,
        token: token,
        user: user.toEntity(),
      );
}
