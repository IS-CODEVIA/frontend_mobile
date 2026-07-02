import '../../domain/entities/transcription_entity.dart';
import '../../domain/repositories/transcription_repository.dart';
import '../datasources/transcription_remote_datasource.dart';

class TranscriptionRepositoryImpl implements TranscriptionRepository {
  final TranscriptionRemoteDataSource remoteDataSource;

  const TranscriptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TranscriptionEntity>> getTranscriptions() async {
    final models = await remoteDataSource.getTranscriptions();
    return models.map((m) => m.toEntity()).toList();
  }
}
