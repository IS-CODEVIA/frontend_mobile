import '../../../../../core/network/api_client.dart';
import '../models/student_material_model.dart';

class StudentMaterialRemoteDataSource {
  final ApiClient apiClient;

  const StudentMaterialRemoteDataSource({required this.apiClient});

  Future<List<StudentMaterialModel>> getMaterials(
      {required int courseId}) async {
    const query = '''
      query(\$courseID: Int!) {
        materials(courseID: \$courseID) {
          materialID
          courseID
          title
          fileURL
          description
          fileType
          createdAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'courseID': courseId},
      requiresAuth: true,
    );

    final list = data['materials'] as List;
    return list
        .map((e) => StudentMaterialModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
