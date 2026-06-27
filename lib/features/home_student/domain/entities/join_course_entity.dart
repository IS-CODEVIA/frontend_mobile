class JoinCourseEntity {
  final int enrollmentId;
  final int studentId;
  final int courseId;
  final String enrolledAt;
  final String status;

  const JoinCourseEntity({
    required this.enrollmentId,
    required this.studentId,
    required this.courseId,
    required this.enrolledAt,
    required this.status,
  });
}
