import '../../../../../core/network/api_client.dart';
import '../models/course_detail_model.dart';

class PeopleRemoteDataSource {
  final ApiClient apiClient;

  const PeopleRemoteDataSource({required this.apiClient});

  Future<CourseDetailModel> getCourseDetail({required int courseId}) async {
    const query = '''
      query(\$courseID: Int!) {
        courseDetail(courseID: \$courseID) {
          teacher {
            userID
            name
            email
            avatarURL
            roleID
          }
          students {
            userID
            name
            email
            avatarURL
            roleID
          }
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'courseID': courseId},
      requiresAuth: true,
    );

    final detail = data['courseDetail'] as Map<String, dynamic>;
    return CourseDetailModel.fromJson(detail);
  }
}
