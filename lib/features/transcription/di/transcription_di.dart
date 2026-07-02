import '../../../core/di/app_container.dart';
import '../data/datasources/transcription_remote_datasource.dart';
import '../data/repositories/transcription_repository_impl.dart';
import '../domain/repositories/transcription_repository.dart';
import '../domain/usecases/get_transcriptions_usecase.dart';

class TranscriptionDI {
  final AppContainer appContainer;

  late final TranscriptionRemoteDataSource transcriptionRemoteDataSource;
  late final TranscriptionRepository transcriptionRepository;
  late final GetTranscriptionsUsecase getTranscriptionsUsecase;

  TranscriptionDI(this.appContainer) {
    _init();
  }

  void _init() {
    transcriptionRemoteDataSource = TranscriptionRemoteDataSource(
      apiClient: appContainer.apiClient,
    );
    transcriptionRepository = TranscriptionRepositoryImpl(
      remoteDataSource: transcriptionRemoteDataSource,
    );
    getTranscriptionsUsecase = GetTranscriptionsUsecase(
      repository: transcriptionRepository,
    );
  }
}
