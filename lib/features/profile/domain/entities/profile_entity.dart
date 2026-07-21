class ProfileEntity {
  final int userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final int roleId;
  final String createdAt;
  final String updatedAt;

  const ProfileEntity({
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });
}
