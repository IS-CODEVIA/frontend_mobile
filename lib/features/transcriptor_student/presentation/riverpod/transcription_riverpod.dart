import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/transcription_service.dart';
import '../../../auth/presentation/riverpod/auth_riverpod.dart';
import '../../domain/models/transcription_message.dart';

class StudentTranscriptionState {
  final List<TranscriptionMessage> messages;
  final String? currentPartial;
  final TranscriptionConnectionState connectionState;
  final String? error;

  const StudentTranscriptionState({
    this.messages = const [],
    this.currentPartial,
    this.connectionState = TranscriptionConnectionState.disconnected,
    this.error,
  });

  StudentTranscriptionState copyWith({
    List<TranscriptionMessage>? messages,
    String? currentPartial,
    TranscriptionConnectionState? connectionState,
    String? error,
  }) {
    return StudentTranscriptionState(
      messages: messages ?? this.messages,
      currentPartial: currentPartial ?? this.currentPartial,
      connectionState: connectionState ?? this.connectionState,
      error: error,
    );
  }
}

class StudentTranscriptionNotifier extends Notifier<StudentTranscriptionState> {
  TranscriptionService? _service;
  StreamSubscription? _partialSub;
  StreamSubscription? _finalSub;
  StreamSubscription? _stateSub;
  StreamSubscription? _errorSub;

  @override
  StudentTranscriptionState build() {
    ref.onDispose(() {
      _partialSub?.cancel();
      _finalSub?.cancel();
      _stateSub?.cancel();
      _errorSub?.cancel();
      _service?.dispose();
    });
    return const StudentTranscriptionState();
  }

  Future<void> connect() async {
    final user = ref.read(authViewModelProvider).user;
    if (user == null) {
      state = state.copyWith(error: 'Debes iniciar sesión primero');
      return;
    }

    _service = TranscriptionService();

    _stateSub = _service!.connectionState.listen((connState) {
      state = state.copyWith(connectionState: connState);
    });

    _errorSub = _service!.errors.listen((err) {
      state = state.copyWith(error: err);
    });

    _partialSub = _service!.partialTranscriptions.listen((data) {
      final text = data['text'] as String? ?? '';
      state = state.copyWith(currentPartial: text);
    });

    _finalSub = _service!.finalTranscriptions.listen((data) {
      final text = data['text'] as String? ?? '';
      final newMsg = TranscriptionMessage(speaker: 'Docente', text: text);
      state = state.copyWith(
        messages: [...state.messages, newMsg],
        currentPartial: null,
      );
    });

    await _service!.connectAndStart(userId: user.userId.toString());
  }

  void disconnect() {
    _service?.stopSession();
    _service?.disconnect();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final transcriptionProvider = NotifierProvider<StudentTranscriptionNotifier, StudentTranscriptionState>(
  StudentTranscriptionNotifier.new,
);
