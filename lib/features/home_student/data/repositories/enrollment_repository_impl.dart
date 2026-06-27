import '../../domain/entities/enrolled_course_entity.dart';
import '../../domain/entities/join_course_entity.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_remote_datasource.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;

  const EnrollmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<JoinCourseEntity> joinCourse(String joinCode) async {
    final model = await remoteDataSource.joinCourse(joinCode);
    return model.toEntity();
  }

  @override
  Future<List<EnrolledCourseEntity>> getMyEnrollments() async {
    final enrollments = await remoteDataSource.getMyEnrollments();

    final results = <EnrolledCourseEntity>[];
    for (final enrollment in enrollments) {
      final courseId = enrollment['courseID'] as int;
      final course = await remoteDataSource.getCourse(courseId);
      results.add(course.toEntity(
        enrollmentId: enrollment['enrollmentID'] as int,
        enrolledAt: enrollment['enrolledAt'] as String,
        status: enrollment['status'] as String,
      ));
    }

    return results;
  }
}
