import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primaryColor = Color.fromARGB(255, 71, 2, 91);
  static const _backgroundColor = Color.fromARGB(255, 14, 1, 58);

  static final TextTheme _textTheme = TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Tajawal'),
    bodyMedium: TextStyle(fontFamily: 'Tajawal'),
    titleLarge: TextStyle(fontFamily: 'Tajawal'),
    titleMedium: TextStyle(fontFamily: 'Tajawal'),
    // Add other text styles as needed
  );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _backgroundColor,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.tajawal(
            color: _primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: _primaryColor),
        ),
        textTheme: _textTheme,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: GoogleFonts.tajawal(color: Colors.grey),
          border: InputBorder.none,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: AppBarTheme(
          color: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: GoogleFonts.tajawal(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: _textTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      );
}
