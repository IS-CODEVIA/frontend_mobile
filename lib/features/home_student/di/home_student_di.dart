import '../../../core/di/app_container.dart';
import '../data/datasources/enrollment_remote_datasource.dart';
import '../data/repositories/enrollment_repository_impl.dart';
import '../domain/repositories/enrollment_repository.dart';
import '../domain/usecases/get_my_enrollments_usecase.dart';
import '../domain/usecases/join_course_usecase.dart';

class HomeStudentDI {
  final AppContainer appContainer;

  late final EnrollmentRemoteDataSource enrollmentRemoteDataSource;
  late final EnrollmentRepository enrollmentRepository;
  late final JoinCourseUsecase joinCourseUsecase;
  late final GetMyEnrollmentsUsecase getMyEnrollmentsUsecase;

  HomeStudentDI(this.appContainer) {
    _init();
  }

  void _init() {
    enrollmentRemoteDataSource = EnrollmentRemoteDataSource(
      apiClient: appContainer.apiClient,
    );

    enrollmentRepository = EnrollmentRepositoryImpl(
      remoteDataSource: enrollmentRemoteDataSource,
    );

    joinCourseUsecase = JoinCourseUsecase(repository: enrollmentRepository);
    getMyEnrollmentsUsecase =
        GetMyEnrollmentsUsecase(repository: enrollmentRepository);
  }
}
