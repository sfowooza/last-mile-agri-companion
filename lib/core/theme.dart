import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF2E7D32);
  static const darkGreen = Color(0xFF1B5E20);
  static const leaf = Color(0xFF66BB6A);
  static const cream = Color(0xFFF7F9F2);
  static const ink = Color(0xFF1B2A1C);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
          onPrimary: Colors.white,
          surface: cream,
          onSurface: ink,
        ),
        scaffoldBackgroundColor: cream,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: darkGreen,
          ),
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: darkGreen,
          ),
          bodyLarge: TextStyle(fontSize: 19, height: 1.45, color: ink),
          bodyMedium: TextStyle(fontSize: 17, height: 1.4, color: ink),
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
}
