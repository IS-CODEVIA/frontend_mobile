import '../entities/auth_payload_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  const LoginUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<AuthPayloadEntity> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
