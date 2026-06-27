import '../../../../../core/network/api_client.dart';
import '../models/material_model.dart';

class MaterialRemoteDataSource {
  final ApiClient apiClient;

  const MaterialRemoteDataSource({required this.apiClient});

  Future<List<MaterialModel>> getMaterials({required int courseId}) async {
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
          uploadedAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {'courseID': courseId},
    );

    final list = data['materials'] as List;
    return list.map((e) => MaterialModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MaterialModel> createMaterial({
    required int courseId,
    required String title,
    required String fileUrl,
    String? description,
    required String fileType,
  }) async {
    const query = '''
      mutation(\$input: CreateMaterialInput!) {
        createMaterial(input: \$input) {
          materialID
          courseID
          title
          fileURL
          description
          fileType
          createdAt
          uploadedAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {
        'input': {
          'courseID': courseId,
          'title': title,
          'fileURL': fileUrl,
          if (description != null) 'description': description,
          'fileType': fileType,
        },
      },
      requiresAuth: true,
    );

    return MaterialModel.fromJson(
      data['createMaterial'] as Map<String, dynamic>,
    );
  }
}
