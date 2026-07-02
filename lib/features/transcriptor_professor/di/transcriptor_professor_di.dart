import '../../../core/di/app_container.dart';
import '../data/datasources/transcription_api_datasource.dart';
import '../data/repositories/class_repository_impl.dart';
import '../domain/repositories/class_repository.dart';
import '../domain/usecases/save_transcription_usecase.dart';

class TranscriptorProfessorDI {
  final AppContainer appContainer;

  late final TranscriptionApiDataSource transcriptionApiDataSource;
  late final ClassRepository classRepository;
  late final SaveTranscriptionUsecase saveTranscriptionUsecase;

  TranscriptorProfessorDI(this.appContainer) {
    _init();
  }

  void _init() {
    transcriptionApiDataSource = TranscriptionApiDataSource(
      apiClient: appContainer.apiClient,
    );
    classRepository = ClassRepositoryImpl(
      dataSource: transcriptionApiDataSource,
    );
    saveTranscriptionUsecase = SaveTranscriptionUsecase(
      repository: classRepository,
    );
  }
}
