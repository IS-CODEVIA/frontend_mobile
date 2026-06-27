import '../../domain/entities/auth_payload_entity.dart';
import 'user_model.dart';

class AuthPayloadModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  const AuthPayloadModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthPayloadModel.fromJson(Map<String, dynamic> json) {
    return AuthPayloadModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  AuthPayloadEntity toEntity() {
    return AuthPayloadEntity(
      user: user.toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
