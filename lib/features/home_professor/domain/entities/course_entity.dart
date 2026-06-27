class CourseEntity {
  final int courseId;
  final String courseName;
  final String section;
  final String period;
  final String joinCode;
  final int subjectId;
  final int teacherId;

  const CourseEntity({
    required this.courseId,
    required this.courseName,
    required this.section,
    required this.period,
    required this.joinCode,
    required this.subjectId,
    required this.teacherId,
  });
}
