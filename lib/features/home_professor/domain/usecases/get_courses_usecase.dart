import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetCoursesUsecase {
  final CourseRepository _repository;

  const GetCoursesUsecase({required CourseRepository repository})
      : _repository = repository;

  Future<List<CourseEntity>> call() {
    return _repository.getCourses();
  }
}
