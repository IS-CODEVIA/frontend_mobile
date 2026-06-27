import '../../../../../core/network/api_client.dart';
import '../models/notice_model.dart';

class NoticeRemoteDataSource {
  final ApiClient apiClient;

  const NoticeRemoteDataSource({required this.apiClient});

  Future<List<NoticeModel>> getNotices({required int courseId}) async {
    const query = '''
      query(\$courseID: Int!) {
        notices(courseID: \$courseID) {
          noticeID
          title
          description
          createdAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'courseID': courseId},
      requiresAuth: true,
    );

    final list = data['notices'] as List;
    return list
        .map((e) => NoticeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<NoticeModel> createNotice({
    required int courseId,
    required String title,
    String? description,
  }) async {
    const query = '''
      mutation(\$input: CreateNoticeInput!) {
        createNotice(input: \$input) {
          noticeID
          title
          description
          createdAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {
        'input': {
          'courseID': courseId,
          'title': title,
          if (description != null) 'description': description,
        },
      },
      requiresAuth: true,
    );

    return NoticeModel.fromJson(
      data['createNotice'] as Map<String, dynamic>,
    );
  }
}
