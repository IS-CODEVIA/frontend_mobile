class NoticeModel {
  final String id;
  final String authorName;
  final String date;
  final String message;
  final String? authorAvatarUrl;

  const NoticeModel({
    required this.id,
    required this.authorName,
    required this.date,
    required this.message,
    this.authorAvatarUrl,
  });
}
