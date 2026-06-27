import '../entities/auth_payload_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _repository;

  const RegisterUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<AuthPayloadEntity> call({
    required String name,
    required String email,
    required String password,
    required int roleId,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      roleId: roleId,
    );
  }
}
