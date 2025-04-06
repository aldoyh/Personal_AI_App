import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/utils/logger.dart';

class ApiService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static Future<String> sendMessage(String message) async {
    final url = baseUrl;
    try {
      logger.d('Making xAI request to: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'messages': [
            {
              'role': 'user',
              'content': message,
            }
          ],
          // xAI specific parameters
          'model': 'x1', // x1 is their latest model
          'stream': false,
          'temperature': 0.7,
          'max_tokens': 800,
          'top_p': 1,
        }),
      );

      logger.d('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices']?[0]?['message']?['content'];
        if (content == null) {
          throw Exception('Invalid response format from xAI API');
        }
        return content;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed: Please check your API key');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded: Please try again later');
      } else {
        throw Exception('xAI API Error (${response.statusCode}): ${response.reasonPhrase}');
      }
    } catch (e) {
      logger.e('xAI Request failed: $e\nURL: $url');
      rethrow;
    }
  }

  static Future<List<String>> getModels() async {
    final url = '${baseUrl.split('/chat')[0]}/models';
    try {
      logger.d('Fetching available models from: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final models = (jsonResponse['data'] as List)
            .map((model) => model['id'] as String)
            .toList();
        return models;
      } else {
        throw Exception('Failed to fetch models: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Failed to get models: $e');
      return ['x1']; // Fallback to default model
    }
  }
}
