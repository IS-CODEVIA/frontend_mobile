import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/chat_service.dart';
import '../../../auth/presentation/riverpod/auth_riverpod.dart';

class ProfessorChatState {
  final bool isConnecting;
  final bool isConnected;
  final String? error;
  final String myUserId;
  final Map<String, int> unread;
  final Map<String, ChatMessage> lastByContact;
  final String? activeContactId;
  final bool isLoadingHistory;
  final List<ChatMessage> messages;
  final bool contactTyping;

  const ProfessorChatState({
    this.isConnecting = false,
    this.isConnected = false,
    this.error,
    this.myUserId = '',
    this.unread = const {},
    this.lastByContact = const {},
    this.activeContactId,
    this.isLoadingHistory = false,
    this.messages = const [],
    this.contactTyping = false,
  });

  ProfessorChatState copyWith({
    bool? isConnecting,
    bool? isConnected,
    String? error,
    String? myUserId,
    Map<String, int>? unread,
    Map<String, ChatMessage>? lastByContact,
    String? activeContactId,
    bool clearActiveContact = false,
    bool? isLoadingHistory,
    List<ChatMessage>? messages,
    bool? contactTyping,
  }) {
    return ProfessorChatState(
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      myUserId: myUserId ?? this.myUserId,
      unread: unread ?? this.unread,
      lastByContact: lastByContact ?? this.lastByContact,
      activeContactId: clearActiveContact
          ? null
          : (activeContactId ?? this.activeContactId),
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      messages: messages ?? this.messages,
      contactTyping: contactTyping ?? this.contactTyping,
    );
  }
}

class ProfessorChatNotifier extends Notifier<ProfessorChatState> {
  ChatService? _service;
  final List<StreamSubscription> _subs = [];

  @override
  ProfessorChatState build() {
    ref.onDispose(close);
    return const ProfessorChatState();
  }

  Future<void> open() async {
    final user = ref.read(authViewModelProvider).asData?.value.user;
    if (user == null) {
      state = state.copyWith(error: 'Debes iniciar sesión primero');
      return;
    }
    final myUserId = user.userId.toString();
    state = ProfessorChatState(isConnecting: true, myUserId: myUserId);

    _service ??= ChatService();
    final service = _service!;
    _listen(service);
    service.connect(userId: myUserId, role: 'teacher');
    _loadInbox();
  }

  void _listen(ChatService service) {
    if (_subs.isNotEmpty) return;
    _subs.addAll([
      service.connection.listen((connected) {
        state = state.copyWith(isConnecting: false, isConnected: connected);
      }),
      service.errors.listen((message) {
        state = state.copyWith(isConnecting: false, error: message);
      }),
      service.messages.listen(_onIncoming),
      service.editedMessages.listen(_onEdited),
      service.receipts.listen(_onReceipt),
      service.typing.listen((event) {
        if (event.senderId == state.activeContactId) {
          state = state.copyWith(contactTyping: event.isTyping);
        }
      }),
    ]);
  }

  Future<void> _loadInbox() async {
    final service = _service;
    if (service == null) return;
    try {
      final conversations = await service.fetchConversations(state.myUserId);
      final unread = {...state.unread};
      final lastByContact = {...state.lastByContact};
      for (final convo in conversations) {
        if (convo.contactId.isEmpty) continue;
        unread[convo.contactId] = convo.unread;
        if (convo.lastMessage != null) {
          lastByContact[convo.contactId] = convo.lastMessage!;
        }
      }
      state = state.copyWith(unread: unread, lastByContact: lastByContact);
    } catch (_) {
      // La bandeja REST es complementaria: si falla, el chat en vivo
      // sigue funcionando con la lista de alumnos del curso.
    }
  }

  String _contactOf(ChatMessage message) =>
      message.senderId == state.myUserId ? message.receiverId : message.senderId;

  void _onIncoming(ChatMessage message) {
    final contactId = _contactOf(message);
    final lastByContact = {...state.lastByContact, contactId: message};

    if (contactId == state.activeContactId) {
      if (state.messages.any((m) => m.id == message.id)) return;
      state = state.copyWith(
        messages: [...state.messages, message],
        lastByContact: lastByContact,
        contactTyping:
            message.senderId == contactId ? false : state.contactTyping,
      );
      if (message.senderId == contactId) {
        _service?.sendReadReceipt([message.id]);
      }
    } else {
      final unread = {...state.unread};
      if (message.senderId != state.myUserId) {
        unread[contactId] = (unread[contactId] ?? 0) + 1;
      }
      state = state.copyWith(unread: unread, lastByContact: lastByContact);
    }
  }

  void _onEdited(ChatMessage message) {
    final contactId = _contactOf(message);
    final lastByContact = {...state.lastByContact};
    if (lastByContact[contactId]?.id == message.id) {
      lastByContact[contactId] = message;
    }
    state = state.copyWith(
      lastByContact: lastByContact,
      messages: contactId == state.activeContactId
          ? [for (final m in state.messages) m.id == message.id ? message : m]
          : null,
    );
  }

  void _onReceipt(ChatReceipt receipt) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages)
          m.id == receipt.messageId
              ? m.copyWith(isDelivered: true, isRead: receipt.read || m.isRead)
              : m,
      ],
    );
  }

  Future<void> openConversation(String contactId) async {
    final service = _service;
    if (service == null) return;
    state = state.copyWith(
      activeContactId: contactId,
      messages: const [],
      isLoadingHistory: true,
      contactTyping: false,
      unread: {...state.unread, contactId: 0},
    );
    try {
      final history = await service.getHistory(contactId: contactId);
      if (state.activeContactId != contactId) return;
      state = state.copyWith(messages: history, isLoadingHistory: false);
      final unreadIds = [
        for (final m in history)
          if (m.senderId == contactId && !m.isRead) m.id,
      ];
      service.sendReadReceipt(unreadIds);
    } catch (e) {
      if (state.activeContactId != contactId) return;
      state = state.copyWith(isLoadingHistory: false, error: e.toString());
    }
  }

  void backToList() {
    state = state.copyWith(
      clearActiveContact: true,
      messages: const [],
      contactTyping: false,
    );
  }

  Future<void> sendMessage(String text) async {
    final contactId = state.activeContactId;
    final service = _service;
    final content = text.trim();
    if (contactId == null || service == null || content.isEmpty) return;

    final res = await service.sendMessage(
      receiverId: contactId,
      content: content,
    );
    if (res.ok && res.message != null) {
      if (state.activeContactId == contactId &&
          !state.messages.any((m) => m.id == res.message!.id)) {
        state = state.copyWith(
          messages: [...state.messages, res.message!],
          lastByContact: {...state.lastByContact, contactId: res.message!},
        );
      }
    } else {
      state = state.copyWith(error: res.error ?? 'No se pudo enviar el mensaje');
    }
  }

  void setTyping(bool isTyping) {
    final contactId = state.activeContactId;
    if (contactId == null) return;
    _service?.sendTyping(receiverId: contactId, isTyping: isTyping);
  }

  void clearError() {
    if (state.error != null) state = state.copyWith(error: null);
  }

  void close() {
    for (final sub in _subs) {
      sub.cancel();
    }
    _subs.clear();
    _service?.dispose();
    _service = null;
    state = const ProfessorChatState();
  }
}

final professorChatProvider =
    NotifierProvider<ProfessorChatNotifier, ProfessorChatState>(
  ProfessorChatNotifier.new,
);
