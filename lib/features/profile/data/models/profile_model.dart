import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  final int userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final int roleId;
  final String createdAt;
  final String updatedAt;

  const ProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['userID'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarURL'] as String?,
      roleId: json['roleID'] as int,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      roleId: roleId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
