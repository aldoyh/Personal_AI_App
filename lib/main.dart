import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/routes/app_router.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'core/config/security_config.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Try loading from different possible locations
    for (final envFile in ['.env', '../.env', '../../.env']) {
      try {
        await dotenv.load(fileName: envFile);
        logger.i('Loaded environment file: $envFile');
        break;
      } catch (e) {
        logger.d('Could not load $envFile: $e');
        continue;
      }
    }

    // Verify environment variables are set
    if (!dotenv.isInitialized || dotenv.env['API_KEY']?.isEmpty == true) {
      throw Exception('Environment not properly configured. Please check .env file.');
    }

    // Initialize error handling
    FlutterError.onError = (details) {
      logger.e('Flutter Error: ${details.exceptionAsString()}',
          stackTrace: details.stack);
    };

    // Initialize environment variables with fallback values
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      logger.w('Failed to load .env file: ${e.toString()}');
      // Set default values if .env loading fails
      dotenv.env['SECURITY_KEY'] = 'default-security-key';
      dotenv.env['API_BASE_URL'] = '';
      dotenv.env['API_KEY'] = 'default-api-key';
    }

    // Validate required environment variables
    final requiredVars = ['SECURITY_KEY', 'API_BASE_URL', 'API_KEY'];
    final missingVars = requiredVars.where((varName) => dotenv.env[varName] == null).toList();
    
    if (missingVars.isNotEmpty) {
      logger.w('Missing required environment variables: ${missingVars.join(', ')}');
      // Set default values for missing variables
      for (final varName in missingVars) {
        dotenv.env[varName] = 'default-$varName';
      }
    }

    try {
      // Initialize security configurations
      SecurityConfig.initializeSecurityConfig();
      
      // Initialize shared preferences
      final prefs = await SharedPreferences.getInstance();
      
      // Check internet connection
      final hasConnection = await InternetConnectionChecker().hasConnection;
      if (!hasConnection) {
        logger.w('No internet connection detected');
      }

      // Setup service locator
      setupServiceLocator();

      runApp(
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(prefs),
          child: const MyApp(),
        ),
      );
    } catch (e, stackTrace) {
      logger.e('Error during initialization', error: e, stackTrace: stackTrace);
      runApp(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Initialization failed: ${e.toString()}'),
            ),
          ),
        ),
      );
    }
  } catch (e, stackTrace) {
    logger.e('Initialization error', error: e, stackTrace: stackTrace);
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Configuration Error: ${e.toString()}\n\nPlease check your .env file configuration.'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        return Banner(
          message: 'DEV',
          location: BannerLocation.topEnd,
          color: Colors.red,
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Add any additional initialization here
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/chat_logo.png', width: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
