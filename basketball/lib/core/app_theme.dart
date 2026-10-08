import 'package:flutter/material.dart';

class CourtKingTheme {
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color slateNavy = Color(0xFF0B1B3D);
  static const Color neonAmber = Color(0xFFFF9900);
  static const Color crispCyan = Color(0xFF00E5FF);
  static const Color dangerRed = Color(0xFFDC2626);
  static const Color surfaceGray = Color(0xFFF8FAFC);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textSubtle = Color(0xFF94A3B8);

  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: pureWhite,
      primaryColor: slateNavy,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: slateNavy,
        secondary: neonAmber,
        surface: pureWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: pureWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: slateNavy),
        titleTextStyle: TextStyle(
          color: slateNavy,
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 1.1,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
