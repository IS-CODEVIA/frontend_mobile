import '../../../../core/network/api_client.dart';
import '../models/class_model.dart';

class TranscriptionApiDataSource {
  final ApiClient apiClient;

  const TranscriptionApiDataSource({required this.apiClient});

  Future<ClassModel> createClass({
    required int courseId,
    required String dateTime,
    required String topic,
  }) async {
    const query = '''
      mutation(\$input: CreateClassInput!) {
        createClass(input: \$input) {
          classID
          courseID
          dateTime
          topic
          createdAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {
        'input': {
          'courseID': courseId,
          'dateTime': dateTime,
          'topic': topic,
        },
      },
      requiresAuth: true,
    );

    return ClassModel.fromJson(
      data['createClass'] as Map<String, dynamic>,
    );
  }

  Future<void> createTranscription({
    required int classId,
    required String fullText,
  }) async {
    const query = '''
      mutation(\$input: CreateTranscriptionInput!) {
        createTranscription(input: \$input) {
          transcriptionID
          classID
          fullText
          createdAt
        }
      }
    ''';

    await apiClient.request(
      query: query,
      variables: {
        'input': {
          'classID': classId,
          'fullText': fullText,
        },
      },
      requiresAuth: true,
    );
  }
}
