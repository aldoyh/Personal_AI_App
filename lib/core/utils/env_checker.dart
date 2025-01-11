import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/logger.dart';

class EnvChecker {
  static bool verifyEnvironmentVariables() {
    try {
      final apiUrl = dotenv.env['API_BASE_URL'];
      final apiKey = dotenv.env['API_KEY'];

      if (apiUrl == null || apiUrl.isEmpty) {
        logger.e('API_BASE_URL is missing or empty');
        return false;
      }

      if (apiKey == null || apiKey.isEmpty) {
        logger.e('API_KEY is missing or empty');
        return false;
      }

      final uri = Uri.parse(apiUrl);
      if (!uri.isAbsolute || !uri.host.contains('chat.x.ai')) {
        logger.e('Invalid API URL format: $apiUrl');
        return false;
      }

      logger.i('Environment verified. API URL: $apiUrl');
      return true;
    } catch (e) {
      logger.e('Environment verification failed: $e');
      return false;
    }
  }
}
