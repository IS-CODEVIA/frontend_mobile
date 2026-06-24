class AssignmentNoticeModel {
  final String id;
  final String authorName;
  final String date;
  final String message;
  final String? authorAvatarUrl;

  const AssignmentNoticeModel({
    required this.id,
    required this.authorName,
    required this.date,
    required this.message,
    this.authorAvatarUrl,
  });
}
