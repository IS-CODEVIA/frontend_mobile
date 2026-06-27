import '../entities/course_detail_entity.dart';
import '../repositories/people_repository.dart';

class GetCourseDetailUsecase {
  final PeopleRepository _repository;

  const GetCourseDetailUsecase({required PeopleRepository repository})
      : _repository = repository;

  Future<CourseDetailEntity> call({required int courseId}) {
    return _repository.getCourseDetail(courseId: courseId);
  }
}
