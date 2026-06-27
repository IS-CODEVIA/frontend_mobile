import '../../domain/entities/course_entity.dart';

class CourseModel {
  final int courseId;
  final String courseName;
  final String section;
  final String period;
  final String joinCode;
  final int subjectId;
  final int teacherId;
  final String createdAt;
  final String? updatedAt;

  const CourseModel({
    required this.courseId,
    required this.courseName,
    required this.section,
    required this.period,
    required this.joinCode,
    required this.subjectId,
    required this.teacherId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseID'] as int,
      courseName: json['courseName'] as String,
      section: json['section'] as String,
      period: json['period'] as String,
      joinCode: json['joinCode'] as String,
      subjectId: json['subjectID'] as int,
      teacherId: json['teacherID'] as int,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  CourseEntity toEntity() {
    return CourseEntity(
      courseId: courseId,
      courseName: courseName,
      section: section,
      period: period,
      joinCode: joinCode,
      subjectId: subjectId,
      teacherId: teacherId,
    );
  }
}
