import '../entities/material_entity.dart';
import '../repositories/material_repository.dart';

class CreateMaterialUsecase {
  final MaterialRepository _repository;

  const CreateMaterialUsecase({required MaterialRepository repository})
      : _repository = repository;

  Future<MaterialEntity> call({
    required int courseId,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  }) {
    return _repository.createMaterial(
      courseId: courseId,
      title: title,
      fileUrl: fileUrl,
      description: description,
      fileType: fileType,
    );
  }
}
