class ChatMessage {
  final String id;
  final String text;
  final String senderName;
  final bool isStudent;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderName,
    required this.isStudent,
    required this.timestamp,
  });
}
