import '../../domain/entities/material_entity.dart';

class MaterialModel {
  final int materialId;
  final int courseId;
  final String title;
  final String fileUrl;
  final String? description;
  final String fileType;
  final String createdAt;
  final String uploadedAt;

  const MaterialModel({
    required this.materialId,
    required this.courseId,
    required this.title,
    required this.fileUrl,
    this.description,
    required this.fileType,
    required this.createdAt,
    required this.uploadedAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      materialId: json['materialID'] as int,
      courseId: json['courseID'] as int,
      title: json['title'] as String,
      fileUrl: json['fileURL'] as String,
      description: json['description'] as String?,
      fileType: json['fileType'] as String,
      createdAt: json['createdAt'] as String,
      uploadedAt: json['uploadedAt'] as String,
    );
  }

  MaterialEntity toEntity() {
    return MaterialEntity(
      materialId: materialId,
      courseId: courseId,
      title: title,
      fileUrl: fileUrl,
      description: description,
      fileType: fileType,
      createdAt: createdAt,
      uploadedAt: uploadedAt,
    );
  }
}
