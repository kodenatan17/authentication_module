import '../../domain/entities/auth_user.dart';

/// JSON-serializable model matching User from API contract.
class UserModel {
  final int id;
  final String name;
  final String phone;
  final String avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatar = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      avatar: (json['avatar'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'avatar': avatar,
      };

  AuthUser toEntity() => AuthUser(
        id: id,
        name: name,
        phone: phone,
        avatar: avatar,
      );
}
