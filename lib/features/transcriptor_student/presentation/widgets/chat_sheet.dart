import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/chat_service.dart';
import '../riverpod/chat_riverpod.dart';

class ChatSheet extends ConsumerStatefulWidget {
  final int courseId;

  const ChatSheet({super.key, required this.courseId});

  @override
  ConsumerState<ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends ConsumerState<ChatSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final ChatNotifier _chat;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _chat = ref.read(chatProvider.notifier);
    Future.microtask(() => _chat.open(widget.courseId));
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final chatState = ref.watch(chatProvider);

    ref.listen(chatProvider.select((s) => s.error), (previous, error) {
      if (error != null && error != previous) {
        _chat.clearError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: colorScheme.error),
        );
      }
    });

    final messages = chatState.messages;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.chat_outlined, color: colorScheme.secondary, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Chat con ${chatState.teacherName}',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: chatState.isConnected
                          ? Colors.green
                          : chatState.isConnecting
                              ? Colors.orange
                              : colorScheme.error,
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Messages list
              Expanded(
                child: chatState.isConnecting && messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : messages.isEmpty
                        ? Center(
                            child: Text(
                              'Envía un mensaje al docente',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            reverse: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg =
                                  messages[messages.length - 1 - index];
                              return _ChatBubble(
                                message: msg,
                                isMine: msg.senderId == chatState.myUserId,
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                              );
                            },
                          ),
              ),
              if (chatState.teacherTyping)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 4),
                    child: Text(
                      '${chatState.teacherName} está escribiendo...',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              // Input field
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
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
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
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
                      IconButton.filled(
                        onPressed: () => _sendMessage(_controller.text),
                        icon: const Icon(Icons.send_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ChatBubble({
    required this.message,
    required this.isMine,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(message.timestamp.toLocal())
        .format(context);
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMine
              ? colorScheme.secondary
              : colorScheme.surfaceContainerHighest,
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
              message.content,
              style: textTheme.bodyMedium?.copyWith(
                color: isMine ? colorScheme.onSecondary : colorScheme.onSurface,
              ),
            ),
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
                        color: isMine
                            ? colorScheme.onSecondary.withValues(alpha: 0.7)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                Text(
                  time,
                  style: textTheme.labelSmall?.copyWith(
                    color: isMine
                        ? colorScheme.onSecondary.withValues(alpha: 0.7)
                        : colorScheme.onSurfaceVariant,
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
                        ? Colors.lightBlueAccent
                        : colorScheme.onSecondary.withValues(alpha: 0.7),
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
