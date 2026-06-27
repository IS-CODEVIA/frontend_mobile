import '../../domain/entities/user_entity.dart';

class UserModel {
  final int userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final int roleId;
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.roleId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userID'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarURL'] as String?,
      roleId: json['roleID'] as int,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      roleId: roleId,
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
    );
  }
}
