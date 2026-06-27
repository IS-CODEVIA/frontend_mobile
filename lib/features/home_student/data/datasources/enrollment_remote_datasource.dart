import '../../../../core/network/api_client.dart';
import '../models/enrolled_course_model.dart';
import '../models/join_course_model.dart';

class EnrollmentRemoteDataSource {
  final ApiClient apiClient;

  const EnrollmentRemoteDataSource({required this.apiClient});

  Future<JoinCourseModel> joinCourse(String joinCode) async {
    const query = '''
      mutation(\$joinCode: String!) {
        joinCourse(joinCode: \$joinCode) {
          enrollmentID
          studentID
          courseID
          enrolledAt
          status
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'joinCode': joinCode},
      requiresAuth: true,
    );

    return JoinCourseModel.fromJson(
      data['joinCourse'] as Map<String, dynamic>,
    );
  }

  Future<List<Map<String, dynamic>>> getMyEnrollments() async {
    const query = '''
      query {
        myEnrollments {
          enrollmentID
          studentID
          courseID
          enrolledAt
          status
        }
      }
    ''';

    final data = await apiClient.request(query: query, requiresAuth: true);
    final list = data['myEnrollments'] as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<EnrolledCourseModel> getCourse(int courseId) async {
    const query = '''
      query(\$courseID: Int!) {
        course(courseID: \$courseID) {
          courseID
          courseName
          section
          period
          joinCode
          subjectID
          teacherID
          createdAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'courseID': courseId},
      requiresAuth: true,
    );

    return EnrolledCourseModel.fromJson(
      data['course'] as Map<String, dynamic>,
    );
  }
}
