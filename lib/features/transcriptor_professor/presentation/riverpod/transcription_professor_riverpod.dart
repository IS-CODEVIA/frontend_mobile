import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import '../../../../core/network/transcription_service.dart';
import '../../../auth/presentation/riverpod/auth_riverpod.dart';

class ProfessorTranscriptionState {
  final TranscriptionConnectionState connectionState;
  final bool isRecording;
  final String? lastPartialText;
  final String? finalText;
  final String? error;
  final List<String> partialHistory;

  const ProfessorTranscriptionState({
    this.connectionState = TranscriptionConnectionState.disconnected,
    this.isRecording = false,
    this.lastPartialText,
    this.finalText,
    this.error,
    this.partialHistory = const [],
  });

  ProfessorTranscriptionState copyWith({
    TranscriptionConnectionState? connectionState,
    bool? isRecording,
    String? lastPartialText,
    String? finalText,
    String? error,
    List<String>? partialHistory,
  }) {
    return ProfessorTranscriptionState(
      connectionState: connectionState ?? this.connectionState,
      isRecording: isRecording ?? this.isRecording,
      lastPartialText: lastPartialText ?? this.lastPartialText,
      finalText: finalText ?? this.finalText,
      error: error,
      partialHistory: partialHistory ?? this.partialHistory,
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

  @override
  ProfessorTranscriptionState build() {
    ref.onDispose(() {
      _stopInternal();
    });
    return const ProfessorTranscriptionState();
  }

  Future<void> startTransmission() async {
    final user = ref.read(authViewModelProvider).user;
    if (user == null) {
      state = state.copyWith(error: 'Debes iniciar sesión primero');
      return;
    }

    state = state.copyWith(error: null);

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
        isRecording: false,
        lastPartialText: null,
      );
    });

    try {
      await _service!.connectAndStart(userId: user.userId.toString());

      final pcmStream = await _recorder!.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      final pcmBuffer = <int>[];
      const maxChunkSize = 131072;

      _audioSub = pcmStream.listen(
        (chunk) {
          pcmBuffer.addAll(chunk);
          while (pcmBuffer.length >= maxChunkSize) {
            _service!.sendAudioChunk(
              Uint8List.sublistView(
                Uint8List.fromList(pcmBuffer),
                0,
                maxChunkSize,
              ),
            );
            pcmBuffer.removeRange(0, maxChunkSize);
          }
        },
        onDone: () {
          if (pcmBuffer.isNotEmpty) {
            _service!.sendAudioChunk(Uint8List.fromList(pcmBuffer));
            pcmBuffer.clear();
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

      final pcmBuffer = <int>[];
      const maxChunkSize = 131072;

      _audioSub = pcmStream.listen(
        (chunk) {
          pcmBuffer.addAll(chunk);
          while (pcmBuffer.length >= maxChunkSize) {
            _service!.sendAudioChunk(
              Uint8List.sublistView(
                Uint8List.fromList(pcmBuffer),
                0,
                maxChunkSize,
              ),
            );
            pcmBuffer.removeRange(0, maxChunkSize);
          }
        },
        onDone: () {
          if (pcmBuffer.isNotEmpty) {
            _service!.sendAudioChunk(Uint8List.fromList(pcmBuffer));
            pcmBuffer.clear();
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
    _service?.stopSession();
    await _recorder?.stop();
    _service?.disconnect();
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
    _audioSub = null;
    _partialSub = null;
    _finalSub = null;
    _stateSub = null;
    _errorSub = null;
    _recorder = null;
    _service = null;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final professorTranscriptionProvider =
    NotifierProvider<ProfessorTranscriptionNotifier, ProfessorTranscriptionState>(
  ProfessorTranscriptionNotifier.new,
);
