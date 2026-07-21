import 'dart:io';

import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateAvatar(File imageFile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  const ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileModel> getProfile() async {
    const query = '''
      query {
        me {
          userID
          name
          email
          roleID
          avatarURL
          createdAt
          updatedAt
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      requiresAuth: true,
    );

    return ProfileModel.fromJson(
      data['me'] as Map<String, dynamic>,
    );
  }

  @override
  Future<ProfileModel> updateAvatar(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final response = await apiClient.uploadFile(
      path: '/upload/avatar',
      fieldName: 'file',
      fileBytes: bytes,
      fileName: 'avatar.jpg',
    );

    return ProfileModel.fromJson(
      response['user'] as Map<String, dynamic>,
    );
  }
}
