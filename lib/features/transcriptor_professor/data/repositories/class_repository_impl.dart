import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/transcription_api_datasource.dart';

class ClassRepositoryImpl implements ClassRepository {
  final TranscriptionApiDataSource dataSource;

  const ClassRepositoryImpl({required this.dataSource});

  @override
  Future<ClassEntity> saveClassAndTranscription({
    required int courseId,
    required String dateTime,
    required String topic,
    required String fullText,
  }) async {
    final classModel = await dataSource.createClass(
      courseId: courseId,
      dateTime: dateTime,
      topic: topic,
    );

    await dataSource.createTranscription(
      classId: classModel.classId,
      fullText: fullText,
    );

    return classModel.toEntity();
  }
}
