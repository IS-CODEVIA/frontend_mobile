import '../../../core/di/app_container.dart';
import '../data/datasources/profile_remote_datasource.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../domain/usecases/update_avatar_usecase.dart';

class ProfileDI {
  final AppContainer appContainer;

  late final ProfileRemoteDataSource profileRemoteDataSource;
  late final ProfileRepository profileRepository;
  late final GetProfileUsecase getProfileUsecase;
  late final UpdateAvatarUsecase updateAvatarUsecase;

  ProfileDI(this.appContainer) {
    _init();
  }

  void _init() {
    profileRemoteDataSource = ProfileRemoteDataSourceImpl(
      apiClient: appContainer.apiClient,
    );

    profileRepository = ProfileRepositoryImpl(
      remoteDataSource: profileRemoteDataSource,
    );

    getProfileUsecase = GetProfileUsecase(repository: profileRepository);
    updateAvatarUsecase = UpdateAvatarUsecase(repository: profileRepository);
  }
}
