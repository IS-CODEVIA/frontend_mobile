import '../../domain/entities/notice_entity.dart';

class NoticeModel {
  final int noticeId;
  final String title;
  final String? description;
  final String createdAt;

  const NoticeModel({
    required this.noticeId,
    required this.title,
    this.description,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeId: json['noticeID'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  NoticeEntity toEntity() {
    return NoticeEntity(
      noticeId: noticeId,
      title: title,
      description: description,
      createdAt: createdAt,
    );
  }
}
