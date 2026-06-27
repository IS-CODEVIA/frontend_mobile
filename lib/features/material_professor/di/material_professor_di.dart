import '../../../core/di/app_container.dart';
import '../data/datasources/material_remote_datasource.dart';
import '../data/repositories/material_repository_impl.dart';
import '../domain/repositories/material_repository.dart';
import '../domain/usecases/create_material_usecase.dart';
import '../domain/usecases/get_materials_usecase.dart';

class MaterialProfessorDI {
  final AppContainer appContainer;

  late final MaterialRemoteDataSource materialRemoteDataSource;
  late final MaterialRepository materialRepository;
  late final GetMaterialsUsecase getMaterialsUsecase;
  late final CreateMaterialUsecase createMaterialUsecase;

  MaterialProfessorDI(this.appContainer) {
    _init();
  }

  void _init() {
    materialRemoteDataSource = MaterialRemoteDataSource(
      apiClient: appContainer.apiClient,
    );
    materialRepository = MaterialRepositoryImpl(
      remoteDataSource: materialRemoteDataSource,
    );
    getMaterialsUsecase = GetMaterialsUsecase(repository: materialRepository);
    createMaterialUsecase = CreateMaterialUsecase(repository: materialRepository);
  }
}
