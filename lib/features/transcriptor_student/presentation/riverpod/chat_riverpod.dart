import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message.dart';

class ChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => [];

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    state = [
      ...state,
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text.trim(),
        senderName: 'Tú',
        isStudent: true,
        timestamp: DateTime.now(),
      ),
    ];
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(ChatNotifier.new);
