import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

class CreateNoticeUsecase {
  final NoticeRepository _repository;

  const CreateNoticeUsecase({required NoticeRepository repository})
      : _repository = repository;

  Future<NoticeEntity> call({
    required int courseId,
    required String title,
    String? description,
  }) {
    return _repository.createNotice(
      courseId: courseId,
      title: title,
      description: description,
    );
  }
}
