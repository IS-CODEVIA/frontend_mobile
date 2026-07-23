import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository _repository;

  const GetProfileUsecase({required ProfileRepository repository})
      : _repository = repository;

  Future<ProfileEntity> call() {
    return _repository.getProfile();
  }
}
