class TranscriptionEntity {
  final int transcriptionId;
  final int classId;
  final int courseId;
  final String fullText;
  final String createdAt;
  final String classTopic;
  final String classDateTime;
  final bool classArchived;

  const TranscriptionEntity({
    required this.transcriptionId,
    required this.classId,
    required this.courseId,
    required this.fullText,
    required this.createdAt,
    required this.classTopic,
    required this.classDateTime,
    required this.classArchived,
  });
}
