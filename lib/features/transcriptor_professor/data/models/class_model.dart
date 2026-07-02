import '../../domain/entities/class_entity.dart';

class ClassModel {
  final int classId;
  final int courseId;
  final String dateTime;
  final String topic;
  final String createdAt;

  const ClassModel({
    required this.classId,
    required this.courseId,
    required this.dateTime,
    required this.topic,
    required this.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classId: json['classID'] as int,
      courseId: json['courseID'] as int,
      dateTime: json['dateTime'] as String,
      topic: json['topic'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  ClassEntity toEntity() {
    return ClassEntity(
      classId: classId,
      courseId: courseId,
      dateTime: dateTime,
      topic: topic,
      createdAt: createdAt,
    );
  }
}
