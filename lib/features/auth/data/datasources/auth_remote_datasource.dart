import '../../../../core/network/api_client.dart';
import '../models/auth_payload_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthPayloadModel> login({
    required String email,
    required String password,
  });

  Future<AuthPayloadModel> register({
    required String name,
    required String email,
    required String password,
    required int roleId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  const AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthPayloadModel> login({
    required String email,
    required String password,
  }) async {
    const query = '''
      mutation(\$input: LoginInput!) {
        login(input: \$input) {
          user { userID name email roleID avatarURL }
          accessToken
          refreshToken
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {
        'input': {
          'email': email,
          'password': password,
        },
      },
    );

    return AuthPayloadModel.fromJson(
      data['login'] as Map<String, dynamic>,
    );
  }

  @override
  Future<AuthPayloadModel> register({
    required String name,
    required String email,
    required String password,
    required int roleId,
  }) async {
    const query = '''
      mutation(\$input: RegisterInput!) {
        register(input: \$input) {
          user { userID name email roleID }
          accessToken
          refreshToken
        }
      }
    ''';

    final data = await apiClient.request(
      query: query,
      variables: {
        'input': {
          'name': name,
          'email': email,
          'password': password,
          'roleID': roleId,
        },
      },
    );

    return AuthPayloadModel.fromJson(
      data['register'] as Map<String, dynamic>,
    );
  }
}
