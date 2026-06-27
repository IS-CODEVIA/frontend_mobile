import '../entities/material_entity.dart';
import '../repositories/material_repository.dart';

class GetMaterialsUsecase {
  final MaterialRepository _repository;

  const GetMaterialsUsecase({required MaterialRepository repository})
      : _repository = repository;

  Future<List<MaterialEntity>> call({required int courseId}) {
    return _repository.getMaterials(courseId: courseId);
  }
}
