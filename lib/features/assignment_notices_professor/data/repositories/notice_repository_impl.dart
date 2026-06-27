import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';
import '../datasources/notice_remote_datasource.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;

  const NoticeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NoticeEntity>> getNotices({required int courseId}) async {
    final models = await remoteDataSource.getNotices(courseId: courseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<NoticeEntity> createNotice({
    required int courseId,
    required String title,
    String? description,
  }) async {
    final model = await remoteDataSource.createNotice(
      courseId: courseId,
      title: title,
      description: description,
    );
    return model.toEntity();
  }
}
