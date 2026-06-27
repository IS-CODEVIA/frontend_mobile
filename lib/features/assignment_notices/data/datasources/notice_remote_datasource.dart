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
}
