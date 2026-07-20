import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/chat_service.dart';
import '../../../auth/presentation/riverpod/auth_riverpod.dart';
import '../../../people_student/domain/models/person_model.dart';
import '../../../people_student/presentation/riverpod/people_student_riverpod.dart';

class StudentChatState {
  final bool isConnecting;
  final bool isConnected;
  final String? error;
  final String myUserId;
  final String? teacherId;
  final String teacherName;
  final List<ChatMessage> messages;
  final bool teacherTyping;

  const StudentChatState({
    this.isConnecting = false,
    this.isConnected = false,
    this.error,
    this.myUserId = '',
    this.teacherId,
    this.teacherName = 'Docente',
    this.messages = const [],
    this.teacherTyping = false,
  });

  StudentChatState copyWith({
    bool? isConnecting,
    bool? isConnected,
    String? error,
    String? myUserId,
    String? teacherId,
    String? teacherName,
    List<ChatMessage>? messages,
    bool? teacherTyping,
  }) {
    return StudentChatState(
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      myUserId: myUserId ?? this.myUserId,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      messages: messages ?? this.messages,
      teacherTyping: teacherTyping ?? this.teacherTyping,
    );
  }
}

class ChatNotifier extends Notifier<StudentChatState> {
  ChatService? _service;
  final List<StreamSubscription> _subs = [];

  @override
  StudentChatState build() {
    ref.onDispose(close);
    return const StudentChatState();
  }

  Future<void> open(int courseId) async {
    final user = ref.read(authViewModelProvider).user;
    if (user == null) {
      state = state.copyWith(error: 'Debes iniciar sesión primero');
      return;
    }
    final myUserId = user.userId.toString();
    state = StudentChatState(isConnecting: true, myUserId: myUserId);

    // Resolver al docente del curso desde la lista de personas.
    var people = ref.read(studentPeopleForCourseProvider(courseId)).people;
    if (people.isEmpty) {
      await ref.read(studentPeopleProvider.notifier).loadPeople(courseId);
      people = ref.read(studentPeopleForCourseProvider(courseId)).people;
    }
    PersonModel? teacher;
    for (final p in people) {
      if (p.role == ClassRole.teacher) {
        teacher = p;
        break;
      }
    }
    if (teacher == null) {
      state = state.copyWith(
        isConnecting: false,
        error: 'No se encontró al docente del curso',
      );
      return;
    }
    state = state.copyWith(teacherId: teacher.id, teacherName: teacher.name);

    _service ??= ChatService();
    final service = _service!;
    _listen(service);
    service.connect(userId: myUserId, role: 'student');
  }

  void _listen(ChatService service) {
    if (_subs.isNotEmpty) return;
    _subs.addAll([
      service.connection.listen((connected) {
        state = state.copyWith(isConnecting: false, isConnected: connected);
        if (connected) _loadHistory();
      }),
      service.errors.listen((message) {
        state = state.copyWith(isConnecting: false, error: message);
      }),
      service.messages.listen(_onIncoming),
      service.editedMessages.listen(_onEdited),
      service.receipts.listen(_onReceipt),
      service.typing.listen((event) {
        if (event.senderId == state.teacherId) {
          state = state.copyWith(teacherTyping: event.isTyping);
        }
      }),
    ]);
  }

  Future<void> _loadHistory() async {
    final teacherId = state.teacherId;
    final service = _service;
    if (teacherId == null || service == null) return;
    try {
      final history = await service.getHistory(contactId: teacherId);
      final merged = _mergeById(history, state.messages);
      state = state.copyWith(messages: merged);
      _markIncomingAsRead(merged);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _onIncoming(ChatMessage message) {
    if (message.senderId != state.teacherId &&
        message.receiverId != state.teacherId) {
      return;
    }
    if (state.messages.any((m) => m.id == message.id)) return;
    state = state.copyWith(
      messages: [...state.messages, message],
      teacherTyping: message.senderId == state.teacherId
          ? false
          : state.teacherTyping,
    );
    if (message.senderId == state.teacherId) {
      _service?.sendReadReceipt([message.id]);
    }
  }

  void _onEdited(ChatMessage message) {
    state = state.copyWith(
      messages: [
        for (final m in state.messages) m.id == message.id ? message : m,
      ],
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

  void _markIncomingAsRead(List<ChatMessage> messages) {
    final unreadIds = [
      for (final m in messages)
        if (m.senderId == state.teacherId && !m.isRead) m.id,
    ];
    _service?.sendReadReceipt(unreadIds);
  }

  List<ChatMessage> _mergeById(List<ChatMessage> base, List<ChatMessage> extra) {
    final result = [...base];
    final ids = {for (final m in base) m.id};
    for (final m in extra) {
      if (!ids.contains(m.id)) result.add(m);
    }
    result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return result;
  }

  Future<void> sendMessage(String text) async {
    final teacherId = state.teacherId;
    final service = _service;
    final content = text.trim();
    if (teacherId == null || service == null || content.isEmpty) return;

    final res = await service.sendMessage(
      receiverId: teacherId,
      content: content,
    );
    if (res.ok && res.message != null) {
      if (!state.messages.any((m) => m.id == res.message!.id)) {
        state = state.copyWith(messages: [...state.messages, res.message!]);
      }
    } else {
      state = state.copyWith(error: res.error ?? 'No se pudo enviar el mensaje');
    }
  }

  void setTyping(bool isTyping) {
    final teacherId = state.teacherId;
    if (teacherId == null) return;
    _service?.sendTyping(receiverId: teacherId, isTyping: isTyping);
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
    state = const StudentChatState();
  }
}

final chatProvider =
    NotifierProvider<ChatNotifier, StudentChatState>(ChatNotifier.new);
