import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/study_plan_model.dart';
import '../../domain/entities/study_plan_entity.dart';

class FeedbackRemoteDataSource {
  static const _baseUrl =
      'https://l1agepurd7n5w3-8080.proxy.runpod.net';

  Future<StudyPlanEntity> generateFeedback({
    required String sessionId,
    required int userId,
    required String transcription,
  }) async {
    final uri = Uri.parse('$_baseUrl/feedback/generate');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'session_id': sessionId,
        'user_id': userId.toString(),
        'transcription': transcription,
        'study_plan': {},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return StudyPlanModel.fromJson(data).toEntity();
    }
    final body = response.body.isNotEmpty ? response.body : 'sin respuesta';
    throw Exception('Error del servidor ($response.statusCode): $body');
  }
}
