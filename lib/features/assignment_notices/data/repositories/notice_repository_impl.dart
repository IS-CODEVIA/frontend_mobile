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
}
