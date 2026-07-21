import '../repositories/course_repository.dart';

class ArchiveClassUsecase {
  final CourseRepository _repository;

  const ArchiveClassUsecase({required CourseRepository repository})
      : _repository = repository;

  Future<void> call(int classId) {
    return _repository.archiveClass(classId);
  }
}
