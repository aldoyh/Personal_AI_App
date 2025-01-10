import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 14, 1, 58),
        appBarTheme: AppBarTheme(
          color: Color(0xFFFFFFFF),
          elevation: 0,
          titleTextStyle: GoogleFonts.tajawal(
            color: const Color.fromARGB(255, 71, 2, 91),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: GoogleFonts.tajawalTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
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
        textTheme: GoogleFonts.tajawalTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      );
}