import '../../../../core/network/api_client.dart';
import '../models/course_model.dart';

class ClassData {
  final int classId;
  final int courseId;
  final bool archived;

  const ClassData({
    required this.classId,
    required this.courseId,
    required this.archived,
  });

  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      classId: json['classID'] as int,
      courseId: json['courseID'] as int,
      archived: json['archived'] as bool? ?? false,
    );
  }
}

class CourseRemoteDataSource {
  final ApiClient apiClient;

  const CourseRemoteDataSource({required this.apiClient});

  Future<List<ClassData>> getClasses(int courseId) async {
    const query = '''
      query(\$courseID: Int!) {
        classes(courseID: \$courseID) {
          classID
          courseID
          archived
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'courseID': courseId},
      requiresAuth: true,
    );

    final list = data['classes'] as List;
    return list.map((e) => ClassData.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> archiveClass(int classId) async {
    const query = '''
      mutation(\$classID: Int!) {
        archiveClass(classID: \$classID) {
          classID
          archived
        }
      }
    ''';

    await apiClient.request(
      query: query,
      variables: {'classID': classId},
      requiresAuth: true,
    );
  }

  Future<void> unarchiveClass(int classId) async {
    const query = '''
      mutation(\$classID: Int!) {
        unarchiveClass(classID: \$classID) {
          classID
          archived
        }
      }
    ''';

    await apiClient.request(
      query: query,
      variables: {'classID': classId},
      requiresAuth: true,
    );
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
