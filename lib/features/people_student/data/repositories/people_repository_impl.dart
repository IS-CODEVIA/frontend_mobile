import '../../domain/entities/course_detail_entity.dart';
import '../../domain/repositories/people_repository.dart';
import '../datasources/people_remote_datasource.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  final PeopleRemoteDataSource remoteDataSource;

  const PeopleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CourseDetailEntity> getCourseDetail({required int courseId}) async {
    final model = await remoteDataSource.getCourseDetail(courseId: courseId);
    return model.toEntity();
  }
}
