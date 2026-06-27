import '../entities/join_course_entity.dart';
import '../repositories/enrollment_repository.dart';

class JoinCourseUsecase {
  final EnrollmentRepository _repository;

  const JoinCourseUsecase({required EnrollmentRepository repository})
      : _repository = repository;

  Future<JoinCourseEntity> call(String joinCode) {
    return _repository.joinCourse(joinCode);
  }
}
