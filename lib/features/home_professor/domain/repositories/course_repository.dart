import '../entities/course_entity.dart';

abstract class CourseRepository {
  Future<List<CourseEntity>> getCourses();
  Future<CourseEntity> createCourse({
    required String courseName,
    required String section,
    required String period,
    required int subjectId,
  });
  Future<void> archiveClass(int classId);
  Future<void> unarchiveClass(int classId);
}
