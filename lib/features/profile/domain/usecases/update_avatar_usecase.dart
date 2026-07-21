import 'dart:io';

import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateAvatarUsecase {
  final ProfileRepository _repository;

  const UpdateAvatarUsecase({required ProfileRepository repository})
      : _repository = repository;

  Future<ProfileEntity> call(File imageFile) {
    return _repository.updateAvatar(imageFile);
  }
}
