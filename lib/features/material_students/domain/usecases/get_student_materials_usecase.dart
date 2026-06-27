import '../entities/student_material_entity.dart';
import '../repositories/student_material_repository.dart';

class GetStudentMaterialsUsecase {
  final StudentMaterialRepository _repository;

  const GetStudentMaterialsUsecase(
      {required StudentMaterialRepository repository})
      : _repository = repository;

  Future<List<StudentMaterialEntity>> call({required int courseId}) {
    return _repository.getMaterials(courseId: courseId);
  }
}
