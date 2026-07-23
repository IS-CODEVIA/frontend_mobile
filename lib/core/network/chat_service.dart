import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;


const String kChatServerHost = 'https://sauuchat.shop';

const String kChatRestUrl = '$kChatServerHost';
const String kChatSocketUrl = '$kChatServerHost';

enum ChatDeliveryStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String? contentOriginal;
  final bool isProcessed;
  final bool isEdited;
  final bool isDelivered;
  final bool isRead;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.contentOriginal,
    this.isProcessed = true,
    this.isEdited = false,
    this.isDelivered = false,
    this.isRead = false,
    required this.timestamp,
  });

  ChatDeliveryStatus get status => isRead
      ? ChatDeliveryStatus.read
      : isDelivered
          ? ChatDeliveryStatus.delivered
          : ChatDeliveryStatus.sent;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      contentOriginal: json['contentOriginal']?.toString(),
      isProcessed: json['isProcessed'] as bool? ?? true,
      isEdited: json['isEdited'] as bool? ?? false,
      isDelivered: json['isDelivered'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? false,
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  ChatMessage copyWith({bool? isDelivered, bool? isRead}) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      contentOriginal: contentOriginal,
      isProcessed: isProcessed,
      isEdited: isEdited,
      isDelivered: isDelivered ?? this.isDelivered,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp,
    );
  }
}

class ChatConversation {
  final String contactId;
  final ChatMessage? lastMessage;
  final int unread;

  const ChatConversation({
    required this.contactId,
    this.lastMessage,
    this.unread = 0,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    final rawLast = json['lastMessage'];
    return ChatConversation(
      contactId: (json['contactId'] ?? json['userId'] ?? json['contact'] ?? '')
          .toString(),
      lastMessage: rawLast is Map
          ? ChatMessage.fromJson(Map<String, dynamic>.from(rawLast))
          : null,
      unread: (json['unread'] as num?)?.toInt() ?? 0,
    );
  }
}

class ChatAckResult {
  final bool ok;
  final String? error;
  final ChatMessage? message;

  const ChatAckResult({required this.ok, this.error, this.message});
}

class ChatReceipt {
  final String messageId;
  final bool read;

  const ChatReceipt({required this.messageId, required this.read});
}

class ChatTyping {
  final String senderId;
  final bool isTyping;

  const ChatTyping({required this.senderId, required this.isTyping});
}

class ChatService {
  io.Socket? _socket;

  final _messageCtrl = StreamController<ChatMessage>.broadcast();
  final _editedCtrl = StreamController<ChatMessage>.broadcast();
  final _receiptCtrl = StreamController<ChatReceipt>.broadcast();
  final _typingCtrl = StreamController<ChatTyping>.broadcast();
  final _connectionCtrl = StreamController<bool>.broadcast();
  final _errorCtrl = StreamController<String>.broadcast();

  Stream<ChatMessage> get messages => _messageCtrl.stream;
  Stream<ChatMessage> get editedMessages => _editedCtrl.stream;
  Stream<ChatReceipt> get receipts => _receiptCtrl.stream;
  Stream<ChatTyping> get typing => _typingCtrl.stream;
  Stream<bool> get connection => _connectionCtrl.stream;
  Stream<String> get errors => _errorCtrl.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect({required String userId, required String role}) {
    if (_socket != null) return;

    _socket = io.io(
      kChatSocketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'userId': userId, 'role': role})
          .build(),
    );

    _socket!
      ..onConnect((_) => _connectionCtrl.add(true))
      ..onDisconnect((_) => _connectionCtrl.add(false))
      ..onConnectError(
          (_) => _errorCtrl.add('No se pudo conectar al servidor de chat'))
      ..on('message', (data) => _messageCtrl.add(ChatMessage.fromJson(_asMap(data))))
      ..on('message_edited',
          (data) => _editedCtrl.add(ChatMessage.fromJson(_asMap(data))))
      ..on('message_delivered', (data) {
        final map = _asMap(data);
        _receiptCtrl.add(ChatReceipt(
          messageId: map['messageId']?.toString() ?? '',
          read: false,
        ));
      })
      ..on('message_read', (data) {
        final map = _asMap(data);
        _receiptCtrl.add(ChatReceipt(
          messageId: map['messageId']?.toString() ?? '',
          read: true,
        ));
      })
      ..on('typing', (data) {
        final map = _asMap(data);
        _typingCtrl.add(ChatTyping(
          senderId: map['senderId']?.toString() ?? '',
          isTyping: map['isTyping'] as bool? ?? false,
        ));
      });
  }

  Future<ChatAckResult> sendMessage({
    required String receiverId,
    required String content,
  }) {
    return _emitWithAck('send_message', {
      'receiverId': receiverId,
      'content': content,
    });
  }

  Future<ChatAckResult> editMessage({
    required String messageId,
    required String content,
  }) {
    return _emitWithAck('edit_message', {
      'messageId': messageId,
      'content': content,
    });
  }

  Future<List<ChatMessage>> getHistory({
    required String contactId,
    int limit = 100,
  }) async {
    final res = await _emitRawAck('get_history', {
      'contactId': contactId,
      'limit': limit,
    });
    if (res['ok'] != true) {
      throw Exception(res['error']?.toString() ?? 'No se pudo cargar el historial');
    }
    final rawMessages = res['messages'];
    if (rawMessages is! List) return const [];
    return rawMessages
        .whereType<Map>()
        .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  void sendReadReceipt(List<String> messageIds) {
    if (messageIds.isEmpty || _socket == null) return;
    _socket!.emitWithAck(
      'read_receipt',
      {'messageIds': messageIds.take(100).toList()},
      ack: (_) {},
    );
  }

  void sendTyping({required String receiverId, required bool isTyping}) {
    _socket?.emit('typing', {'receiverId': receiverId, 'isTyping': isTyping});
  }

  Future<List<ChatConversation>> fetchConversations(String userId) async {
    final response = await http
        .get(Uri.parse('$kChatRestUrl/api/conversations/$userId'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Error HTTP ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    final list = decoded is List
        ? decoded
        : decoded is Map
            ? (decoded['conversations'] ?? decoded['data'] ?? const [])
            : const [];
    if (list is! List) return const [];
    return list
        .whereType<Map>()
        .map((c) => ChatConversation.fromJson(Map<String, dynamic>.from(c)))
        .toList();
  }

  Future<ChatAckResult> _emitWithAck(String event, Map<String, dynamic> data) async {
    try {
      final res = await _emitRawAck(event, data);
      final rawMessage = res['message'];
      return ChatAckResult(
        ok: res['ok'] == true,
        error: res['error']?.toString(),
        message: rawMessage is Map
            ? ChatMessage.fromJson(Map<String, dynamic>.from(rawMessage))
            : null,
      );
    } catch (e) {
      return ChatAckResult(ok: false, error: e.toString());
    }
  }

  Future<Map<String, dynamic>> _emitRawAck(
    String event,
    Map<String, dynamic> data,
  ) {
    final socket = _socket;
    if (socket == null) {
      return Future.value({'ok': false, 'error': 'Chat no conectado'});
    }
    final completer = Completer<Map<String, dynamic>>();
    socket.emitWithAck(event, data, ack: (dynamic response) {
      if (!completer.isCompleted) {
        completer.complete(_asMap(response));
      }
    });
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => {'ok': false, 'error': 'Sin respuesta del servidor'},
    );
  }

  Map<String, dynamic> _asMap(dynamic data) {
    var value = data;
    if (value is List && value.isNotEmpty) value = value.first;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {'ok': false, 'error': 'Respuesta inválida del servidor'};
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _messageCtrl.close();
    _editedCtrl.close();
    _receiptCtrl.close();
    _typingCtrl.close();
    _connectionCtrl.close();
    _errorCtrl.close();
  }
}
