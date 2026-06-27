import '../entities/material_entity.dart';

abstract class MaterialRepository {
  Future<List<MaterialEntity>> getMaterials({required int courseId});
  Future<MaterialEntity> createMaterial({
    required int courseId,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  });
}
