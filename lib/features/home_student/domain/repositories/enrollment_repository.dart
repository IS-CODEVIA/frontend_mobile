import '../entities/enrolled_course_entity.dart';
import '../entities/join_course_entity.dart';

abstract class EnrollmentRepository {
  Future<JoinCourseEntity> joinCourse(String joinCode);
  Future<List<EnrolledCourseEntity>> getMyEnrollments();
}
