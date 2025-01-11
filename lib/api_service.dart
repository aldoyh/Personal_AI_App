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
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        throw Exception('xAI API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logger.e('xAI Request failed: $e\nURL: $url');
      return 'Error: $e';
    }
  }

  static getModels() {
    // TODO: Implement this method to get the list of models from xAI API
    
  }
}
