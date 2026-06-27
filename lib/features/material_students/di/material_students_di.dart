import '../../../core/di/app_container.dart';
import '../data/datasources/student_material_remote_datasource.dart';
import '../data/repositories/student_material_repository_impl.dart';
import '../domain/repositories/student_material_repository.dart';
import '../domain/usecases/get_student_materials_usecase.dart';

class MaterialStudentsDI {
  final AppContainer appContainer;

  late final StudentMaterialRemoteDataSource studentMaterialRemoteDataSource;
  late final StudentMaterialRepository studentMaterialRepository;
  late final GetStudentMaterialsUsecase getStudentMaterialsUsecase;

  MaterialStudentsDI(this.appContainer) {
    _init();
  }

  void _init() {
    studentMaterialRemoteDataSource = StudentMaterialRemoteDataSource(
      apiClient: appContainer.apiClient,
    );

    studentMaterialRepository = StudentMaterialRepositoryImpl(
      remoteDataSource: studentMaterialRemoteDataSource,
    );

    getStudentMaterialsUsecase = GetStudentMaterialsUsecase(
      repository: studentMaterialRepository,
    );
  }
}
