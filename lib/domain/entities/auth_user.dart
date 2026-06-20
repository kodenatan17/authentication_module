import 'package:equatable/equatable.dart';

/// Authenticated user information.
class AuthUser extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String avatar;

  const AuthUser({
    required this.id,
    required this.name,
    required this.phone,
    this.avatar = '',
  });

  AuthUser copyWith({
    int? id,
    String? name,
    String? phone,
    String? avatar,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, avatar];
}
