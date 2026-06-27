class EnrolledCourseEntity {
  final int enrollmentId;
  final int courseId;
  final String courseName;
  final String section;
  final String period;
  final int subjectId;
  final int teacherId;
  final String enrolledAt;
  final String status;

  const EnrolledCourseEntity({
    required this.enrollmentId,
    required this.courseId,
    required this.courseName,
    required this.section,
    required this.period,
    required this.subjectId,
    required this.teacherId,
    required this.enrolledAt,
    required this.status,
  });
}
