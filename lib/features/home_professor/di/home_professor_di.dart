import '../../../core/di/app_container.dart';
import '../data/datasources/course_remote_datasource.dart';
import '../data/repositories/course_repository_impl.dart';
import '../domain/repositories/course_repository.dart';
import '../domain/usecases/create_course_usecase.dart';
import '../domain/usecases/get_courses_usecase.dart';

class HomeProfessorDI {
  final AppContainer appContainer;

  late final CourseRemoteDataSource courseRemoteDataSource;
  late final CourseRepository courseRepository;
  late final GetCoursesUsecase getCoursesUsecase;
  late final CreateCourseUsecase createCourseUsecase;

  HomeProfessorDI(this.appContainer) {
    _init();
  }

  void _init() {
    courseRemoteDataSource = CourseRemoteDataSource(
      apiClient: appContainer.apiClient,
    );
    courseRepository = CourseRepositoryImpl(
      remoteDataSource: courseRemoteDataSource,
    );
    getCoursesUsecase = GetCoursesUsecase(repository: courseRepository);
    createCourseUsecase = CreateCourseUsecase(repository: courseRepository);
  }
}
