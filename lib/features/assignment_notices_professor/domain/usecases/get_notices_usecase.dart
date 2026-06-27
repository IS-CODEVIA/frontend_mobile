import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

class GetNoticesUsecase {
  final NoticeRepository _repository;

  const GetNoticesUsecase({required NoticeRepository repository})
      : _repository = repository;

  Future<List<NoticeEntity>> call({required int courseId}) {
    return _repository.getNotices(courseId: courseId);
  }
}
