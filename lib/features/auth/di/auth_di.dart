import '../../../core/di/app_container.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';

class AuthDI {
  final AppContainer appContainer;

  late final AuthRemoteDataSource authRemoteDataSource;
  late final AuthRepository authRepository;
  late final LoginUsecase loginUsecase;
  late final RegisterUsecase registerUsecase;

  AuthDI(this.appContainer) {
    _init();
  }

  void _init() {
    authRemoteDataSource = AuthRemoteDataSourceImpl(
      apiClient: appContainer.apiClient,
    );

    authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
    );

    loginUsecase = LoginUsecase(repository: authRepository);
    registerUsecase = RegisterUsecase(repository: authRepository);
  }
}
