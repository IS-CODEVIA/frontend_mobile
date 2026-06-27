import '../../domain/entities/join_course_entity.dart';

class JoinCourseModel {
  final int enrollmentId;
  final int studentId;
  final int courseId;
  final String enrolledAt;
  final String status;

  const JoinCourseModel({
    required this.enrollmentId,
    required this.studentId,
    required this.courseId,
    required this.enrolledAt,
    required this.status,
  });

  factory JoinCourseModel.fromJson(Map<String, dynamic> json) {
    return JoinCourseModel(
      enrollmentId: json['enrollmentID'] as int,
      studentId: json['studentID'] as int,
      courseId: json['courseID'] as int,
      enrolledAt: json['enrolledAt'] as String,
      status: json['status'] as String,
    );
  }

  JoinCourseEntity toEntity() {
    return JoinCourseEntity(
      enrollmentId: enrollmentId,
      studentId: studentId,
      courseId: courseId,
      enrolledAt: enrolledAt,
      status: status,
    );
  }
}
