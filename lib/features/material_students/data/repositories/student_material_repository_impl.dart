import '../../domain/entities/student_material_entity.dart';
import '../../domain/repositories/student_material_repository.dart';
import '../datasources/student_material_remote_datasource.dart';

class StudentMaterialRepositoryImpl implements StudentMaterialRepository {
  final StudentMaterialRemoteDataSource remoteDataSource;

  const StudentMaterialRepositoryImpl(
      {required this.remoteDataSource});

  @override
  Future<List<StudentMaterialEntity>> getMaterials(
      {required int courseId}) async {
    final models =
        await remoteDataSource.getMaterials(courseId: courseId);
    return models.map((m) => m.toEntity()).toList();
  }
}
