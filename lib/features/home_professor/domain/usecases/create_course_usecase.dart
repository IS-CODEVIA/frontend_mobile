import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class CreateCourseUsecase {
  final CourseRepository _repository;

  const CreateCourseUsecase({required CourseRepository repository})
      : _repository = repository;

  Future<CourseEntity> call({
    required String courseName,
    required String section,
    required String period,
  }) {
    return _repository.createCourse(
      courseName: courseName,
      section: section,
      period: period,
    );
  }
}
