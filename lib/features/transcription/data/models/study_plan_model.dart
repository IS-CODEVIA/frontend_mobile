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
      summary: json['resumen'] as String? ?? '',
      keyTopics: (json['ideas_clave'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      strengths: (json['conexiones'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      areasToImprove: (json['temas_confusos'] as List? ?? [])
          .map((e) {
            final tema = (e as Map<String, dynamic>)['tema'] as String? ?? '';
            final explicacion =
                (e)['explicacion'] as String? ?? '';
            return '$tema: $explicacion';
          })
          .toList(),
      recommendations: (json['recomendaciones'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      engagementEstimate: 0.0,
      suggestedReview: '',
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
