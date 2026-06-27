import '../entities/course_detail_entity.dart';

abstract class PeopleRepository {
  Future<CourseDetailEntity> getCourseDetail({required int courseId});
}
