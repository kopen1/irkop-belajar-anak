import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color Palette — PRD C.2
class AppColors {
  static const Color primary = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
  static const Color pink = Color(0xFFEC4899);
  static const Color blue = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF5F3FF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF1E1B4B);
}

/// Tema Nunito rounded — PRD C.3
class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: brightness),
      scaffoldBackgroundColor: brightness == Brightness.light
          ? AppColors.background
          : const Color(0xFF17143A),
    );
    return base.copyWith(textTheme: GoogleFonts.nunitoTextTheme(base.textTheme));
  }
}
