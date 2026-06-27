import '../entities/notice_entity.dart';

abstract class NoticeRepository {
  Future<List<NoticeEntity>> getNotices({required int courseId});
  Future<NoticeEntity> createNotice({
    required int courseId,
    required String title,
    String? description,
  });
}
