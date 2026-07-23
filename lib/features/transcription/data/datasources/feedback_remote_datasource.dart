import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/study_plan_model.dart';
import '../../domain/entities/study_plan_entity.dart';

class FeedbackRemoteDataSource {
  static const _baseUrl = 'https://e6omtu6oi9j7p7-8080.proxy.runpod.net';

  Future<FeedbackEntity> getFeedback({
    required String sessionId,
  }) async {
    final uri = Uri.parse('$_baseUrl/feedback/$sessionId');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FeedbackModel.fromJson(data).toEntity();
    }
    if (response.statusCode == 404) {
      throw Exception('FEEDBACK_NOT_FOUND');
    }
    final errorBody = response.body.isNotEmpty ? response.body : 'sin respuesta';
    throw Exception('Error del servidor ($response.statusCode): $errorBody');
  }

  Future<FeedbackEntity> generateFeedback({
    required String sessionId,
    required int userId,
    Map<String, dynamic>? studyPlan,
  }) async {
    final uri = Uri.parse('$_baseUrl/feedback/generate');
    final body = <String, dynamic>{
      'session_id': sessionId,
      'user_id': userId.toString(),
    };
    if (studyPlan != null) {
      body['study_plan'] = studyPlan;
    }

    print('[FeedbackRemoteDataSource] POST $uri');
    print('[FeedbackRemoteDataSource] session_id: $sessionId');
    print('[FeedbackRemoteDataSource] body: ${jsonEncode(body)}');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return FeedbackModel.fromJson(data).toEntity();
    }
    final errorBody = response.body.isNotEmpty ? response.body : 'sin respuesta';
    throw Exception('Error del servidor ($response.statusCode): $errorBody');
  }
}
