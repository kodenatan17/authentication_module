/// Authenticated user information.
class AuthUser {
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          avatar == other.avatar;

  @override
  int get hashCode => Object.hash(id, name, phone, avatar);
}
