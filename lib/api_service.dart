import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personal_ai_app/constants/api_consts.dart';
import 'package:personal_ai_app/models/models_model.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse('$BASE_URL/models'),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );
      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw Exception(jsonResponse['error']['message']);
      }

      return ModelsModel.modelsFromSnapshot(jsonResponse['data']);
    } catch (e) {
      throw Exception('Failed to load models: $e');
    }
  }
}
