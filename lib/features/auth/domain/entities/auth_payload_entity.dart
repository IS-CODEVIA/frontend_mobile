import 'user_entity.dart';

class AuthPayloadEntity {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;

  const AuthPayloadEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}
