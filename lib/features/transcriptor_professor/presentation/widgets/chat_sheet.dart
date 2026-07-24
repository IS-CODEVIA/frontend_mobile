import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/chat_service.dart';
import '../../../people_professor/domain/models/person_model.dart';
import '../../../people_professor/presentation/riverpod/people_professor_riverpod.dart';
import '../riverpod/chat_professor_riverpod.dart';

class ChatSheet extends ConsumerStatefulWidget {
  final int courseId;

  const ChatSheet({super.key, required this.courseId});

  @override
  ConsumerState<ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends ConsumerState<ChatSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final ProfessorChatNotifier _chat;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _chat = ref.read(professorChatProvider.notifier);
    Future.microtask(() {
      _chat.open();
      ref
          .read(professorPeopleProvider.notifier)
          .loadPeople(widget.courseId);
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    _chat.close();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (!_isTyping) {
      _isTyping = true;
      _chat.setTyping(true);
    }
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      _isTyping = false;
      _chat.setTyping(false);
    });
  }

  void _sendMessage(String text) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _typingTimer?.cancel();
    if (_isTyping) {
      _isTyping = false;
      _chat.setTyping(false);
    }
    _chat.sendMessage(text);
    _controller.clear();
    _formKey.currentState?.reset();
  }

  void _openConversation(String contactId) {
    _controller.clear();
    _chat.openConversation(contactId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final chatState = ref.watch(professorChatProvider);
    final peopleState =
        ref.watch(professorPeopleForCourseProvider(widget.courseId));

    ref.listen(professorChatProvider.select((s) => s.error),
        (previous, error) {
      if (error != null && error != previous) {
        _chat.clearError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: colorScheme.error),
        );
      }
    });

    final students = (peopleState.asData?.value.people ?? <PersonModel>[])
        .where((p) => p.role == ClassRole.student)
        .toList();
    final activeContactId = chatState.activeContactId;
    final activeStudent = activeContactId == null
        ? null
        : students.where((s) => s.id == activeContactId).firstOrNull;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                if (activeContactId != null)
                  IconButton(
                    onPressed: _chat.backToList,
                    icon: Icon(Icons.arrow_back,
                        color: colorScheme.onSecondary),
                  )
                else
                  const SizedBox(width: 48),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, color: colorScheme.onSecondary, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          activeContactId == null
                              ? 'Mensajes de alumnos'
                              : activeStudent?.name ??
                                  'Alumno $activeContactId',
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.circle,
                    size: 10,
                    color: chatState.isConnected
                        ? Colors.greenAccent
                        : chatState.isConnecting
                            ? Colors.orangeAccent
                            : Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: activeContactId == null
                ? _StudentList(
                    students: students,
                    isLoading: peopleState.isLoading,
                    chatState: chatState,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: _openConversation,
                  )
                : _ConversationView(
                    chatState: chatState,
                    contactName: activeStudent?.name ?? 'Alumno',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
          ),
          if (activeContactId != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        maxLength: 2000,
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onChanged: _onTextChanged,
                        onFieldSubmitted: _sendMessage,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '';
                          }
                          if (value.trim().length > 2000) {
                            return 'Máximo 2000 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _sendMessage(_controller.text),
                      icon: Icon(Icons.send_rounded, color: colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StudentList extends StatelessWidget {
  final List<PersonModel> students;
  final bool isLoading;
  final ProfessorChatState chatState;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final void Function(String contactId) onTap;

  const _StudentList({
    required this.students,
    required this.isLoading,
    required this.chatState,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && students.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (students.isEmpty) {
      return Center(
        child: Text(
          'No hay alumnos en este curso',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: students.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final student = students[index];
        final unread = chatState.unread[student.id] ?? 0;
        final last = chatState.lastByContact[student.id];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: colorScheme.secondaryContainer,
            child: Text(
              student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
          ),
          title: Text(student.name),
          subtitle: last != null
              ? Text(
                  last.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          trailing: unread > 0
              ? CircleAvatar(
                  radius: 12,
                  backgroundColor: colorScheme.secondary,
                  child: Text(
                    '$unread',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          onTap: () => onTap(student.id),
        );
      },
    );
  }
}

class _ConversationView extends StatelessWidget {
  final ProfessorChatState chatState;
  final String contactName;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ConversationView({
    required this.chatState,
    required this.contactName,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    if (chatState.isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }
    final messages = chatState.messages;
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Text(
                    'Envía un mensaje a $contactName',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    return _ChatBubble(
                      message: msg,
                      isMine: msg.senderId == chatState.myUserId,
                      senderName: contactName,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    );
                  },
                ),
        ),
        if (chatState.contactTyping)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                '$contactName está escribiendo...',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final String senderName;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ChatBubble({
    required this.message,
    required this.isMine,
    required this.senderName,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final time =
        TimeOfDay.fromDateTime(message.timestamp.toLocal()).format(context);
    final showOriginal = !isMine &&
        message.contentOriginal != null &&
        message.contentOriginal!.isNotEmpty &&
        message.contentOriginal != message.content;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMine ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMine ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isMine ? 'Tú' : senderName,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(message.content, style: textTheme.bodyMedium),
            if (showOriginal) ...[
              const SizedBox(height: 4),
              Text(
                'Original: ${message.contentOriginal}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isEdited)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      '(editado)',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                Text(
                  time,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.status == ChatDeliveryStatus.sent
                        ? Icons.check
                        : Icons.done_all,
                    size: 14,
                    color: message.status == ChatDeliveryStatus.read
                        ? Colors.blue
                        : colorScheme.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
