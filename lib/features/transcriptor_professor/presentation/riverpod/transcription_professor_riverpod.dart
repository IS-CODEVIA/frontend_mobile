export '../../../../core/network/transcription_service.dart'
    show TranscriptionConnectionState;

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

import '../../../../core/di/app_container.dart';
import '../../../../core/network/transcription_service.dart';
import '../../../auth/presentation/riverpod/auth_riverpod.dart';
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

class ProfessorTranscriptionState {
  final TranscriptionConnectionState connectionState;
  final bool isRecording;
  final String? lastPartialText;
  final String? finalText;
  final String? error;
  final List<String> partialHistory;
  final List<String> finalHistory;

  const ProfessorTranscriptionState({
    this.connectionState = TranscriptionConnectionState.disconnected,
    this.isRecording = false,
    this.lastPartialText,
    this.finalText,
    this.error,
    this.partialHistory = const [],
    this.finalHistory = const [],
  });

  ProfessorTranscriptionState copyWith({
    TranscriptionConnectionState? connectionState,
    bool? isRecording,
    String? lastPartialText,
    String? finalText,
    String? error,
    List<String>? partialHistory,
    List<String>? finalHistory,
  }) {
    return ProfessorTranscriptionState(
      connectionState: connectionState ?? this.connectionState,
      isRecording: isRecording ?? this.isRecording,
      lastPartialText: lastPartialText ?? this.lastPartialText,
      finalText: finalText ?? this.finalText,
      error: error,
      partialHistory: partialHistory ?? this.partialHistory,
      finalHistory: finalHistory ?? this.finalHistory,
    );
  }
}

class ProfessorTranscriptionNotifier
    extends Notifier<ProfessorTranscriptionState> {
  TranscriptionService? _service;
  AudioRecorder? _recorder;
  StreamSubscription? _audioSub;
  StreamSubscription? _partialSub;
  StreamSubscription? _finalSub;
  StreamSubscription? _stateSub;
  StreamSubscription? _errorSub;
  final List<int> _pcmBuffer = [];
  static const int _maxChunkSize = 131072;

  @override
  ProfessorTranscriptionState build() {
    ref.onDispose(() {
      _stopInternal();
    });
    return const ProfessorTranscriptionState();
  }

  String _sessionIdForCourse(int courseId) => 'live:$courseId';

  Future<void> startTransmission(int courseId) async {
    final user = ref.read(authViewModelProvider).asData?.value.user;
    if (user == null) {
      state = state.copyWith(error: 'Debes iniciar sesión primero');
      return;
    }

    _stopInternal();
    _pcmBuffer.clear();
    state = const ProfessorTranscriptionState();

    _service = TranscriptionService();
    _recorder = AudioRecorder();

    _stateSub = _service!.connectionState.listen((connState) {
      state = state.copyWith(connectionState: connState);
    });

    _errorSub = _service!.errors.listen((err) {
      state = state.copyWith(error: err);
    });

    _partialSub = _service!.partialTranscriptions.listen((data) {
      final text = data['text'] as String? ?? '';
      state = state.copyWith(
        lastPartialText: text,
        partialHistory: [...state.partialHistory, text],
      );
    });

    _finalSub = _service!.finalTranscriptions.listen((data) {
      final text = data['text'] as String? ?? '';
      state = state.copyWith(
        finalText: text,
        finalHistory: [...state.finalHistory, text],
        lastPartialText: null,
      );
    });

    try {
      await _service!.connectAndStart(
        userId: user.userId.toString(),
        sessionId: _sessionIdForCourse(courseId),
      );

      final pcmStream = await _recorder!.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _audioSub = pcmStream.listen(
        (chunk) {
          _pcmBuffer.addAll(chunk);
          while (_pcmBuffer.length >= _maxChunkSize) {
            _sendChunk();
          }
        },
        onError: (err) {
          state = state.copyWith(error: 'Audio error: $err');
        },
      );

      state = state.copyWith(isRecording: true);
    } catch (e) {
      state = state.copyWith(error: 'Error al iniciar: $e');
    }
  }

  void pauseTransmission() {
    _audioSub?.cancel();
    state = state.copyWith(isRecording: false);
  }

  Future<void> resumeTransmission() async {
    if (_recorder == null) return;
    try {
      final pcmStream = await _recorder!.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _audioSub = pcmStream.listen(
        (chunk) {
          _pcmBuffer.addAll(chunk);
          while (_pcmBuffer.length >= _maxChunkSize) {
            _sendChunk();
          }
        },
        onError: (err) => state = state.copyWith(error: 'Audio error: $err'),
      );
      state = state.copyWith(isRecording: true);
    } catch (e) {
      state = state.copyWith(error: 'Error al reanudar: $e');
    }
  }

  Future<void> stopTransmission() async {
    _audioSub?.cancel();

    if (_pcmBuffer.isNotEmpty) {
      _sendChunk();
    }

    await Future.delayed(const Duration(milliseconds: 200));
    await _service?.sendStopAndWaitForFinal();
    await _recorder?.stop();
    state = state.copyWith(isRecording: false);
  }

  void _stopInternal() {
    _audioSub?.cancel();
    _partialSub?.cancel();
    _finalSub?.cancel();
    _stateSub?.cancel();
    _errorSub?.cancel();
    _recorder?.dispose();
    _service?.dispose();
    _pcmBuffer.clear();
    _audioSub = null;
    _partialSub = null;
    _finalSub = null;
    _stateSub = null;
    _errorSub = null;
    _recorder = null;
    _service = null;
  }

  void _sendChunk() {
    if (_pcmBuffer.isEmpty) return;
    final chunkLength =
        _pcmBuffer.length > _maxChunkSize ? _maxChunkSize : _pcmBuffer.length;
    _service!.sendAudioChunk(
      Uint8List.sublistView(Uint8List.fromList(_pcmBuffer), 0, chunkLength),
    );
    _pcmBuffer.removeRange(0, chunkLength);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final professorTranscriptionProvider =
    NotifierProvider<ProfessorTranscriptionNotifier, ProfessorTranscriptionState>(
  ProfessorTranscriptionNotifier.new,
);

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

class SaveTranscriptionNotifier extends Notifier<SaveTranscriptionState> {
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

final saveTranscriptionProvider =
    NotifierProvider<SaveTranscriptionNotifier, SaveTranscriptionState>(
  SaveTranscriptionNotifier.new,
);
