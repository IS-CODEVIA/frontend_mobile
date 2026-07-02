import '../../../../core/network/api_client.dart';
import '../models/transcription_model.dart';

class TranscriptionRemoteDataSource {
  final ApiClient apiClient;

  const TranscriptionRemoteDataSource({required this.apiClient});

  Future<List<TranscriptionModel>> getTranscriptions() async {
    const query = '''
      query {
        transcriptions {
          transcriptionID
          classID
          fullText
          createdAt
          class {
            classID
            courseID
            dateTime
            topic
            archived
          }
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      requiresAuth: true,
    );

    final list = data['transcriptions'] as List;
    return list
        .map((e) => TranscriptionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
