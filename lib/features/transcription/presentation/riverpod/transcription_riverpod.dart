import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/transcription_di.dart';
import '../../domain/entities/transcription_entity.dart';
import '../../domain/usecases/get_transcriptions_usecase.dart';

final _diProvider = Provider<TranscriptionDI>((ref) {
  return TranscriptionDI(ref.watch(appContainerProvider)!);
});

final _getTranscriptionsUsecaseProvider = Provider<GetTranscriptionsUsecase>(
  (ref) => ref.watch(_diProvider).getTranscriptionsUsecase,
);

final transcriptionsProvider =
    NotifierProvider<TranscriptionsNotifier, List<TranscriptionEntity>>(
  TranscriptionsNotifier.new,
);

final transcriptionsByCourseIdProvider =
    Provider.family<List<TranscriptionEntity>, int>((ref, courseId) {
  final all = ref.watch(transcriptionsProvider);
  return all.where((t) => t.courseId == courseId).toList();
});

class TranscriptionsNotifier extends Notifier<List<TranscriptionEntity>> {
  @override
  List<TranscriptionEntity> build() => [];

  Future<void> loadTranscriptions() async {
    try {
      final transcriptions =
          await ref.read(_getTranscriptionsUsecaseProvider)();
      transcriptions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = transcriptions;
    } catch (_) {}
  }
}
