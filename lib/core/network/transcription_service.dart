import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';

enum TranscriptionConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

class TranscriptionService {
  WebSocketChannel? _channel;
  final _uuid = const Uuid();
  String? _sessionId;
  String? _userId;
  Timer? _reconnectTimer;
  bool _intentionalDisconnect = false;

  final _partialCtrl = StreamController<Map<String, dynamic>>.broadcast();
  final _finalCtrl = StreamController<Map<String, dynamic>>.broadcast();
  final _stateCtrl =
      StreamController<TranscriptionConnectionState>.broadcast();
  final _errorCtrl = StreamController<String>.broadcast();

  Stream<Map<String, dynamic>> get partialTranscriptions =>
      _partialCtrl.stream;
  Stream<Map<String, dynamic>> get finalTranscriptions => _finalCtrl.stream;
  Stream<TranscriptionConnectionState> get connectionState =>
      _stateCtrl.stream;
  Stream<String> get errors => _errorCtrl.stream;

  String? get sessionId => _sessionId;
  TranscriptionConnectionState get currentState => _currentState;
  TranscriptionConnectionState _currentState =
      TranscriptionConnectionState.disconnected;

  Future<void> connectAndStart({
    required String userId,
    String language = 'es',
    String? sessionId,
    String mode = 'speaker',
  }) async {
    if (_currentState == TranscriptionConnectionState.connected) return;
    _intentionalDisconnect = false;
    _userId = userId;
    _updateState(TranscriptionConnectionState.connecting);

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://e6omtu6oi9j7p7-8000.proxy.runpod.net/ws/transcribe'),
      );

      await _channel!.ready;

      _sessionId = sessionId ?? _uuid.v4();
      _sendJson({
        'type': 'start',
        'session_id': _sessionId,
        'user_id': _userId,
        'mode': mode,
        'language': language,
      });

      _updateState(TranscriptionConnectionState.connected);

      _channel!.stream.listen(
        _onMessage,
        onError: (error) {
          _errorCtrl.add('WebSocket error: $error');
          _updateState(TranscriptionConnectionState.error);
          _scheduleReconnect();
        },
        onDone: () {
          _updateState(TranscriptionConnectionState.disconnected);
          _scheduleReconnect();
        },
      );
    } catch (e) {
      _errorCtrl.add('Connection failed: $e');
      _updateState(TranscriptionConnectionState.error);
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_intentionalDisconnect) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_intentionalDisconnect) return;
      if (_userId != null) {
        connectAndStart(userId: _userId!, sessionId: _sessionId);
      }
    });
  }

  void _onMessage(dynamic message) {
    if (message is String) {
      try {
        final data = jsonDecode(message) as Map<String, dynamic>;
        final type = data['type'] as String?;

        switch (type) {
          case 'heartbeat':
            _sendJson({'type': 'pong'});
          case 'partial_transcription':
            _partialCtrl.add(data);
          case 'final_transcription':
            _finalCtrl.add(data);
        }
      } catch (_) {}
    }
  }

  void sendAudioChunk(Uint8List chunk) {
    if (_channel != null &&
        _currentState == TranscriptionConnectionState.connected) {
      if (kDebugMode) {
        print(
            'sendAudioChunk: user_id=$_userId, session_id=$_sessionId, chunkSize=${chunk.length}');
      }
      _channel!.sink.add(chunk);
    }
  }

  void sendRawMessage(String message) {
    if (_channel != null &&
        _currentState == TranscriptionConnectionState.connected) {
      _channel!.sink.add(message);
    }
  }

  void stopSession() {
    _sendJson({'type': 'stop'});
  }

  Future<void> sendStopAndWaitForFinal(
      {Duration timeout = const Duration(seconds: 10)}) async {
    _sendJson({'type': 'stop'});
    final completer = Completer<void>();
    StreamSubscription? sub;
    sub = _finalCtrl.stream.listen((_) {
      sub?.cancel();
      if (!completer.isCompleted) completer.complete();
    });
    await completer.future.timeout(timeout, onTimeout: () => sub?.cancel());
    disconnect();
  }

  void disconnect() {
    _intentionalDisconnect = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _updateState(TranscriptionConnectionState.disconnected);
  }

  void _sendJson(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void _updateState(TranscriptionConnectionState state) {
    _currentState = state;
    _stateCtrl.add(state);
  }

  void dispose() {
    _intentionalDisconnect = true;
    disconnect();
    _partialCtrl.close();
    _finalCtrl.close();
    _stateCtrl.close();
    _errorCtrl.close();
  }
}
