import '../entities/class_entity.dart';

abstract class ClassRepository {
  Future<ClassEntity> saveClassAndTranscription({
    required int courseId,
    required String dateTime,
    required String topic,
    required String fullText,
  });
}
