import '../../../home_professor/domain/entities/course_entity.dart';

class ArchivedSubjectProfessorModel {
  final int courseId;
  final String title;
  final String subtitle;
  final int colorSeed;

  const ArchivedSubjectProfessorModel({
    required this.courseId,
    required this.title,
    required this.subtitle,
    this.colorSeed = 0,
  });

  factory ArchivedSubjectProfessorModel.fromCourse(CourseEntity course, int colorSeed) {
    return ArchivedSubjectProfessorModel(
      courseId: course.courseId,
      title: course.courseName,
      subtitle: course.section,
      colorSeed: colorSeed,
    );
  }
}
