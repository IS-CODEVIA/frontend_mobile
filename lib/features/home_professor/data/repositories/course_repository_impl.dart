import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  const CourseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CourseEntity>> getCourses() async {
    final models = await remoteDataSource.getCourses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> archiveClass(int classId) async {
    await remoteDataSource.archiveClass(classId);
  }

  @override
  Future<void> unarchiveClass(int classId) async {
    await remoteDataSource.unarchiveClass(classId);
  }

  @override
  Future<CourseEntity> createCourse({
    required String courseName,
    required String section,
    required String period,
    required int subjectId,
  }) async {
    final model = await remoteDataSource.createCourse(
      courseName: courseName,
      section: section,
      period: period,
      subjectId: subjectId,
    );
    return model.toEntity();
  }
}
