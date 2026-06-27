import '../../../core/di/app_container.dart';
import '../data/datasources/people_remote_datasource.dart';
import '../data/repositories/people_repository_impl.dart';
import '../domain/repositories/people_repository.dart';
import '../domain/usecases/get_course_detail_usecase.dart';

class PeopleProfessorDI {
  final AppContainer appContainer;

  late final PeopleRemoteDataSource peopleRemoteDataSource;
  late final PeopleRepository peopleRepository;
  late final GetCourseDetailUsecase getCourseDetailUsecase;

  PeopleProfessorDI(this.appContainer) {
    _init();
  }

  void _init() {
    peopleRemoteDataSource = PeopleRemoteDataSource(
      apiClient: appContainer.apiClient,
    );

    peopleRepository = PeopleRepositoryImpl(
      remoteDataSource: peopleRemoteDataSource,
    );

    getCourseDetailUsecase =
        GetCourseDetailUsecase(repository: peopleRepository);
  }
}
