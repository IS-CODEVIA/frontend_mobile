import '../../domain/entities/student_material_entity.dart';

class StudentMaterialModel {
  final int materialId;
  final int courseId;
  final String title;
  final String fileUrl;
  final String? description;
  final String fileType;
  final String createdAt;

  const StudentMaterialModel({
    required this.materialId,
    required this.courseId,
    required this.title,
    required this.fileUrl,
    this.description,
    required this.fileType,
    required this.createdAt,
  });

  factory StudentMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudentMaterialModel(
      materialId: json['materialID'] as int,
      courseId: json['courseID'] as int,
      title: json['title'] as String,
      fileUrl: json['fileURL'] as String,
      description: json['description'] as String?,
      fileType: json['fileType'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  StudentMaterialEntity toEntity() {
    return StudentMaterialEntity(
      materialId: materialId,
      courseId: courseId,
      title: title,
      fileUrl: fileUrl,
      description: description,
      fileType: fileType,
      createdAt: createdAt,
    );
  }
}
