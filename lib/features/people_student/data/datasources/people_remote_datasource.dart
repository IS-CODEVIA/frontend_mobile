import '../../../../../core/network/api_client.dart';
import '../models/course_detail_model.dart';

class PeopleRemoteDataSource {
  final ApiClient apiClient;

  const PeopleRemoteDataSource({required this.apiClient});

  Future<CourseDetailModel> getCourseDetail({required int courseId}) async {
    const query = '''
      query(\$courseID: Int!) {
        courseParticipants(courseID: \$courseID) {
          userID
          name
          email
          role
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'courseID': courseId},
      requiresAuth: true,
    );

    final list = data['courseParticipants'] as List;
    return CourseDetailModel.fromParticipants(
      list.cast<Map<String, dynamic>>(),
    );
  }
}
