import '../entities/auth_payload_entity.dart';

abstract class AuthRepository {
  Future<AuthPayloadEntity> login({
    required String email,
    required String password,
  });

  Future<AuthPayloadEntity> register({
    required String name,
    required String email,
    required String password,
    required int roleId,
  });
}
