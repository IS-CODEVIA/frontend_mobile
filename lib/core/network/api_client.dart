import 'dart:convert';

import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';

class ApiClient {
  final String baseUrl;
  final TokenStorage tokenStorage;

  ApiClient({required this.baseUrl, required this.tokenStorage});

  Future<Map<String, dynamic>> request({
    required String query,
    Map<String, dynamic>? variables,
    bool requiresAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final body = jsonEncode({
      'query': query,
      if (variables != null) 'variables': variables,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (decoded.containsKey('errors')) {
      final errors = decoded['errors'] as List;
      final message = errors.isNotEmpty
          ? errors.first['message'] as String? ?? 'Error desconocido'
          : 'Error desconocido';
      throw ApiException(message);
    }

    return decoded['data'] as Map<String, dynamic>;
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
