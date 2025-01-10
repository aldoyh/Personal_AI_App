import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personal_ai_app/models_model.dart';
import 'core/utils/logger.dart';
import 'api_consts.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        Uri.parse('$baseUrl/models'),
      );

      if (response.statusCode != 200) {
        throw HttpException('Failed to load models');
      }

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      logger.e('Error in getModels: $error');
      rethrow;
    }
  }

  static Future<String> sendMessage(String message) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': message,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode != 200) {
        throw HttpException('Failed to send message');
      }

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      return jsonResponse['choices'][0]['text'].toString();
    } catch (error) {
      logger.e('Error in sendMessage: $error');
      rethrow;
    }
  }
}
