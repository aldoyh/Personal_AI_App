import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/utils/logger.dart';

class ApiService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static Future<String> sendMessage(String message) async {
    final url = baseUrl;  // No need to append /chat/completions as it's in the base URL
    try {
      logger.d('Making request to: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'messages': [
            {
              'role': 'user',
              'content': message,
            }
          ],
        }),
      );

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logger.e('Request failed: $e\nURL: $url');
      return 'Error: $e';
    }
  }

  static Future<dynamic> getModels() async {
    // call the base Url but with /models endpoint
    final url = '$baseUrl/models';
    try {
      logger.d('Fetching models from: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      logger.d('Response status: ${response.statusCode}');
      logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logger.e('Request failed: $e URL: $url');
      return 'Error: $e';
    
    }

  }
}
