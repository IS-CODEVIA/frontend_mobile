import '../entities/transcription_entity.dart';
import '../repositories/transcription_repository.dart';

class GetTranscriptionsUsecase {
  final TranscriptionRepository _repository;

  const GetTranscriptionsUsecase({
    required TranscriptionRepository repository,
  }) : _repository = repository;

  Future<List<TranscriptionEntity>> call() {
    return _repository.getTranscriptions();
  }
}
