import '../repositories/course_repository.dart';

class UnarchiveClassUsecase {
  final CourseRepository _repository;

  const UnarchiveClassUsecase({required CourseRepository repository})
      : _repository = repository;

  Future<void> call(int classId) {
    return _repository.unarchiveClass(classId);
  }
}
