import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/logger.dart';

class EnvChecker {
  static bool verifyEnvironmentVariables() {
    try {
      final apiUrl = dotenv.env['API_BASE_URL'];
      final apiKey = dotenv.env['API_KEY'];

      if (apiUrl == null || apiUrl.isEmpty) {
        logger.e('xAI API_BASE_URL is missing or empty');
        return false;
      }

      if (apiKey == null || apiKey.isEmpty || !apiKey.startsWith('xai-')) {
        logger.e('Invalid xAI API key format');
        return false;
      }

      final uri = Uri.parse(apiUrl);
      if (!uri.isAbsolute || !uri.host.contains('x.ai')) {
        logger.e('Invalid xAI API URL format: $apiUrl');
        return false;
      }

      logger.i('xAI environment verified successfully');
      return true;
    } catch (e) {
      logger.e('xAI environment verification failed: $e');
      return false;
    }
  }
}
