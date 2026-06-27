import '../../domain/entities/enrolled_course_entity.dart';

class EnrolledCourseModel {
  final int courseId;
  final String courseName;
  final String section;
  final String period;
  final int subjectId;
  final int teacherId;
  final String createdAt;

  const EnrolledCourseModel({
    required this.courseId,
    required this.courseName,
    required this.section,
    required this.period,
    required this.subjectId,
    required this.teacherId,
    required this.createdAt,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    return EnrolledCourseModel(
      courseId: json['courseID'] as int,
      courseName: json['courseName'] as String,
      section: json['section'] as String,
      period: json['period'] as String,
      subjectId: json['subjectID'] as int,
      teacherId: json['teacherID'] as int,
      createdAt: json['createdAt'] as String,
    );
  }

  EnrolledCourseEntity toEntity({
    required int enrollmentId,
    required String enrolledAt,
    required String status,
  }) {
    return EnrolledCourseEntity(
      enrollmentId: enrollmentId,
      courseId: courseId,
      courseName: courseName,
      section: section,
      period: period,
      subjectId: subjectId,
      teacherId: teacherId,
      enrolledAt: enrolledAt,
      status: status,
    );
  }
}
