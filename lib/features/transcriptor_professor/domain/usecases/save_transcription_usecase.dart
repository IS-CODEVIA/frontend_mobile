import '../entities/class_entity.dart';
import '../repositories/class_repository.dart';

class SaveTranscriptionUsecase {
  final ClassRepository _repository;

  const SaveTranscriptionUsecase({required ClassRepository repository})
      : _repository = repository;

  Future<ClassEntity> call({
    required int courseId,
    required String dateTime,
    required String topic,
    required String fullText,
  }) {
    return _repository.saveClassAndTranscription(
      courseId: courseId,
      dateTime: dateTime,
      topic: topic,
      fullText: fullText,
    );
  }
}
