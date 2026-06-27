import '../entities/student_material_entity.dart';

abstract class StudentMaterialRepository {
  Future<List<StudentMaterialEntity>> getMaterials({required int courseId});
}
