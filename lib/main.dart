import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
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
      home: const ChatScreen(),
    );
  }
}
