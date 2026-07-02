import '../../domain/entities/transcription_entity.dart';

class TranscriptionModel {
  final int transcriptionId;
  final int classId;
  final int courseId;
  final String fullText;
  final String createdAt;
  final String classTopic;
  final String classDateTime;
  final bool classArchived;

  const TranscriptionModel({
    required this.transcriptionId,
    required this.classId,
    required this.courseId,
    required this.fullText,
    required this.createdAt,
    required this.classTopic,
    required this.classDateTime,
    required this.classArchived,
  });

  factory TranscriptionModel.fromJson(Map<String, dynamic> json) {
    final classData = json['class'] as Map<String, dynamic>;
    return TranscriptionModel(
      transcriptionId: json['transcriptionID'] as int,
      classId: json['classID'] as int,
      courseId: classData['courseID'] as int,
      fullText: json['fullText'] as String,
      createdAt: json['createdAt'] as String,
      classTopic: classData['topic'] as String? ?? '',
      classDateTime: classData['dateTime'] as String? ?? '',
      classArchived: classData['archived'] as bool? ?? false,
    );
  }

  TranscriptionEntity toEntity() {
    return TranscriptionEntity(
      transcriptionId: transcriptionId,
      classId: classId,
      courseId: courseId,
      fullText: fullText,
      createdAt: createdAt,
      classTopic: classTopic,
      classDateTime: classDateTime,
      classArchived: classArchived,
    );
  }
}
