import 'package:flutter/material.dart';
import 'package:personal_ai_app/constants/constants.dart';
import 'package:personal_ai_app/screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kScaffoldBackgroundColor,
        appBarTheme: AppBarTheme(
          color: kCardColor,
        ),
      ),
      home: ChatScreen(),
    );
  }
}
