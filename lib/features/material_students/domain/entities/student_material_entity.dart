class StudentMaterialEntity {
  final int materialId;
  final int courseId;
  final String title;
  final String fileUrl;
  final String? description;
  final String fileType;
  final String createdAt;

  const StudentMaterialEntity({
    required this.materialId,
    required this.courseId,
    required this.title,
    required this.fileUrl,
    this.description,
    required this.fileType,
    required this.createdAt,
  });
}
