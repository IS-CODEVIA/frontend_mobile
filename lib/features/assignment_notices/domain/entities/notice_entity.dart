class NoticeEntity {
  final int noticeId;
  final String title;
  final String? description;
  final String createdAt;

  const NoticeEntity({
    required this.noticeId,
    required this.title,
    this.description,
    required this.createdAt,
  });
}
