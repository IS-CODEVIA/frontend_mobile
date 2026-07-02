import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/transcriptor_professor_di.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/usecases/save_transcription_usecase.dart';

final _transcriptorProfessorDIProvider =
    Provider<TranscriptorProfessorDI>((ref) {
  return TranscriptorProfessorDI(ref.watch(appContainerProvider)!);
});

final _saveTranscriptionUsecaseProvider =
    Provider<SaveTranscriptionUsecase>((ref) {
  return ref.watch(_transcriptorProfessorDIProvider).saveTranscriptionUsecase;
});

class SaveTranscriptionState {
  final bool isSaving;
  final String? error;
  final bool isSuccess;
  final ClassEntity? createdClass;

  const SaveTranscriptionState({
    this.isSaving = false,
    this.error,
    this.isSuccess = false,
    this.createdClass,
  });

  SaveTranscriptionState copyWith({
    bool? isSaving,
    String? error,
    bool? isSuccess,
    ClassEntity? createdClass,
  }) {
    return SaveTranscriptionState(
      isSaving: isSaving ?? this.isSaving,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      createdClass: createdClass ?? this.createdClass,
    );
  }
}

class SaveTranscriptionNotifier
    extends Notifier<SaveTranscriptionState> {
  @override
  SaveTranscriptionState build() => const SaveTranscriptionState();

  Future<bool> save({
    required int courseId,
    required String dateTime,
    required String topic,
    required String fullText,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final result = await ref.read(_saveTranscriptionUsecaseProvider)(
        courseId: courseId,
        dateTime: dateTime,
        topic: topic,
        fullText: fullText,
      );
      state = state.copyWith(
        isSaving: false,
        isSuccess: true,
        createdClass: result,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const SaveTranscriptionState();
  }
}

final saveTranscriptionProvider = NotifierProvider<
    SaveTranscriptionNotifier, SaveTranscriptionState>(
  SaveTranscriptionNotifier.new,
);
