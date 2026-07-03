class FeedbackEntity {
  final String sessionId;
  final String summary;
  final List<String> keyTopics;
  final List<String> strengths;
  final List<String> areasToImprove;
  final List<String> recommendations;
  final double engagementEstimate;
  final String suggestedReview;

  const FeedbackEntity({
    required this.sessionId,
    required this.summary,
    required this.keyTopics,
    required this.strengths,
    required this.areasToImprove,
    required this.recommendations,
    required this.engagementEstimate,
    required this.suggestedReview,
  });
}
