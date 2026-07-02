import '../entities/transcription_entity.dart';

abstract class TranscriptionRepository {
  Future<List<TranscriptionEntity>> getTranscriptions();
}
