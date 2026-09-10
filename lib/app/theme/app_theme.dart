import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF0F1C2E);
  static const inkSoft = Color(0xFF3A4A63);
  static const inkMuted = Color(0xFF6A7994);
  static const line = Color(0xFFE5E8F0);
  static const ocean = Color(0xFF0F62B4);
  static const oceanLight = Color(0xFF77A1D3);
  static const tealLight = Color(0xFF79CBCA);
  static const error = Color(0xFFD43B57);
  static const backgroundTop = Color(0xFFACE0F9);
  static const backgroundBottom = Color(0xFFFFF1EB);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.ocean,
      brightness: Brightness.light,
      primary: AppColors.ocean,
      error: AppColors.error,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: AppColors.ink,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(color: AppColors.inkSoft, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.inkSoft, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 16),
        labelStyle: const TextStyle(color: AppColors.inkSoft),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.oceanLight, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.6),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ocean,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
