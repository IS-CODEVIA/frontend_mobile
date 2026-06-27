class MaterialEntity {
  final int materialId;
  final int courseId;
  final String title;
  final String fileUrl;
  final String? description;
  final String fileType;
  final String createdAt;
  final String uploadedAt;

  const MaterialEntity({
    required this.materialId,
    required this.courseId,
    required this.title,
    required this.fileUrl,
    this.description,
    required this.fileType,
    required this.createdAt,
    required this.uploadedAt,
  });
}
