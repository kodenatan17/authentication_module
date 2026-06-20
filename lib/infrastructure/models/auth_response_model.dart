import 'package:equatable/equatable.dart';
import 'package:core_module/core_module.dart';
import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

/// JSON-serializable model matching AuthResponse from API contract.
class AuthResponseModel extends Equatable implements ResponseMapper<AuthResult> {
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

  @override
  AuthResult toDomain() => AuthResult(
        success: success,
        token: token,
        user: user.toDomain(),
      );

  @override
  List<Object?> get props => [success, token, user];
}
