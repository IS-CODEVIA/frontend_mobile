import '../../domain/entities/material_entity.dart';
import '../../domain/repositories/material_repository.dart';
import '../datasources/material_remote_datasource.dart';

class MaterialRepositoryImpl implements MaterialRepository {
  final MaterialRemoteDataSource remoteDataSource;

  const MaterialRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MaterialEntity>> getMaterials({required int courseId}) async {
    final models = await remoteDataSource.getMaterials(courseId: courseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<MaterialEntity> createMaterial({
    required int courseId,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  }) async {
    final model = await remoteDataSource.createMaterial(
      courseId: courseId,
      title: title,
      fileUrl: fileUrl,
      description: description,
      fileType: fileType,
    );
    return model.toEntity();
  }
}
