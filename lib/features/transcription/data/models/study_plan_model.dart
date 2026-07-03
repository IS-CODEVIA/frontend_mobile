import '../../domain/entities/study_plan_entity.dart';

class FeedbackModel {
  final String sessionId;
  final String summary;
  final List<String> keyTopics;
  final List<String> strengths;
  final List<String> areasToImprove;
  final List<String> recommendations;
  final double engagementEstimate;
  final String suggestedReview;

  const FeedbackModel({
    required this.sessionId,
    required this.summary,
    required this.keyTopics,
    required this.strengths,
    required this.areasToImprove,
    required this.recommendations,
    required this.engagementEstimate,
    required this.suggestedReview,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      sessionId: json['session_id'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      keyTopics: (json['key_topics'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      strengths: (json['strengths'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      areasToImprove: (json['areas_to_improve'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      engagementEstimate: (json['engagement_estimate'] as num?)?.toDouble() ?? 0.0,
      suggestedReview: json['suggested_review'] as String? ?? '',
    );
  }

  FeedbackEntity toEntity() {
    return FeedbackEntity(
      sessionId: sessionId,
      summary: summary,
      keyTopics: keyTopics,
      strengths: strengths,
      areasToImprove: areasToImprove,
      recommendations: recommendations,
      engagementEstimate: engagementEstimate,
      suggestedReview: suggestedReview,
    );
  }
}
