import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colors and type extracted from the design mockup
/// (ai_daily_meal_planner_design/AI Daily Meal Planner.dc.html).
class AppColors {
  AppColors._();

  static const canvas = Color(0xFFEAE9EE);
  static const background = Color(0xFFFBFBFC);
  static const surface = Color(0xFFFFFFFF);

  static const accent = Color(0xFF5B46E5);
  static const accentDark = Color(0xFF4A37C9);
  static const gradientStart = Color(0xFF5B6EF0);
  static const gradientEnd = Color(0xFF6B46E5);
  static const accentSurface = Color(0xFFEEECFB);

  static const textPrimary = Color(0xFF1A1A1A);
  static const textStrong = Color(0xFF141414);
  static const textHeading = Color(0xFF161616);
  static const textBody = Color(0xFF4A4A4A);
  static const textMuted = Color(0xFF6B6B6B);
  static const textFaint = Color(0xFF7A7A7A);
  static const textFainter = Color(0xFF8A8A8A);
  static const textSubtle = Color(0xFF9A9A9A);
  static const textGhost = Color(0xFFA0A0A0);
  static const textPale = Color(0xFFB0B0B0);

  static const border = Color(0xFFEEEEEE);
  static const borderStrong = Color(0xFFECECEC);
  static const borderFaint = Color(0xFFF0F0F0);
  static const chipBorder = Color(0xFFE6E6E6);
  static const disabled = Color(0xFFC9C6D6);

  static const warningBg = Color(0xFFFDF6E3);
  static const warningBorder = Color(0xFFF0E2B8);
  static const warningText = Color(0xFF8A6A1F);
  static const warningIcon = Color(0xFFB6892A);

  static const scrim = Color(0x6B141414);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );
}

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme() => GoogleFonts.hankenGroteskTextTheme();

  static TextStyle mono({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textMuted,
    double? letterSpacing,
  }) =>
      GoogleFonts.spaceMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        primary: AppColors.accent,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
