import '../../domain/entities/auth_payload_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthPayloadEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await remoteDataSource.login(
      email: email,
      password: password,
    );
    return model.toEntity();
  }

  @override
  Future<AuthPayloadEntity> register({
    required String name,
    required String email,
    required String password,
    required int roleId,
  }) async {
    final model = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      roleId: roleId,
    );
    return model.toEntity();
  }
}
