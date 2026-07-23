import 'dart:convert';
import 'package:http/http.dart' as http;

class StudyPlanService {
  static const _baseUrl = 'https://e6omtu6oi9j7p7-8080.proxy.runpod.net';

  Future<Map<String, dynamic>> generateStudyPlan({
    required String userId,
    required String sessionId,
    String? topic,
    String difficulty = 'intermedio',
    int durationHours = 6,
    List<String> focusAreas = const [],
  }) async {
    final uri = Uri.parse('$_baseUrl/study-plan/generate');
    final body = {
      'user_id': userId,
      'session_id': sessionId,
      'topic': topic ?? '',
      'difficulty': difficulty,
      'duration_hours': durationHours,
      'focus_areas': focusAreas,
    };
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    if (response.statusCode == 404) {
      throw Exception('La sesión aún está en proceso. Intenta en unos minutos.');
    }
    throw Exception('Error ${response.statusCode} en $uri: ${response.body}');
  }

  Future<Map<String, dynamic>> getStudyPlan(String sessionId) async {
    final uri = Uri.parse('$_baseUrl/study-plan/$sessionId');
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    if (response.statusCode == 404) {
      throw Exception('No se encontró el plan de estudio.');
    }
    throw Exception('Error del servidor (${response.statusCode})');
  }
}
