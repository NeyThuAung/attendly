enum UserRole {
  admin,
  user;

  String get name => this == UserRole.admin ? 'admin' : 'user';
}

class UserEntity {
  final String uid;
  final String email;
  final String name;
  final String? profileImageUrl;
  final UserRole role;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.role,
    required this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin;
}
