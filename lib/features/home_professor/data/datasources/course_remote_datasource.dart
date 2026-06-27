import '../../../../core/network/api_client.dart';
import '../models/course_model.dart';

class SubjectData {
  final int subjectId;
  final String subjectName;

  const SubjectData({required this.subjectId, required this.subjectName});

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      subjectId: json['subjectID'] as int,
      subjectName: json['subjectName'] as String,
    );
  }
}

class CourseRemoteDataSource {
  final ApiClient apiClient;

  const CourseRemoteDataSource({required this.apiClient});

  Future<List<SubjectData>> getSubjects() async {
    const query = '''
      query {
        subjects {
          subjectID
          subjectName
        }
      }
    ''';

    final data = await apiClient.request(query: query);
    final list = data['subjects'] as List;
    return list.map((e) => SubjectData.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CourseModel>> getCourses() async {
    const query = '''
      query {
        courses {
          courseID
          courseName
          section
          period
          joinCode
          subjectID
          teacherID
          createdAt
          updatedAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      requiresAuth: true,
    );

    final list = data['courses'] as List;
    return list.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CourseModel> createCourse({
    required String courseName,
    required String section,
    required String period,
    required int subjectId,
  }) async {
    const query = '''
      mutation(\$input: CreateCourseInput!) {
        createCourse(input: \$input) {
          courseID
          courseName
          section
          period
          joinCode
          subjectID
          teacherID
          createdAt
          updatedAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {
        'input': {
          'courseName': courseName,
          'section': section,
          'period': period,
          'subjectID': subjectId,
        },
      },
      requiresAuth: true,
    );

    return CourseModel.fromJson(
      data['createCourse'] as Map<String, dynamic>,
    );
  }
}
