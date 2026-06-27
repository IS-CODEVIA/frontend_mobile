import '../entities/enrolled_course_entity.dart';
import '../repositories/enrollment_repository.dart';

class GetMyEnrollmentsUsecase {
  final EnrollmentRepository _repository;

  const GetMyEnrollmentsUsecase({required EnrollmentRepository repository})
      : _repository = repository;

  Future<List<EnrolledCourseEntity>> call() {
    return _repository.getMyEnrollments();
  }
}
