import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds — deep space navy
  static const Color backgroundDark = Color(0xFF05070D);
  static const Color backgroundLight = Color(0xFF0A0F1A);
  static const Color cardBackground = Color(0xFF0D1522);
  static const Color cardHover = Color(0xFF13202F);
  static const Color cardActive = Color(0xFF1A2A3D);

  // Accents — electric cyan / violet / pink
  static const Color accentPrimary = Color(0xFF22D3EE);
  static const Color accentSecondary = Color(0xFFA78BFA);
  static const Color accentTertiary = Color(0xFFF471B5);
  static const Color accentWarm = Color(0xFFF59E0B);

  // Legacy aliases for gradual migration
  static const Color primaryDark = backgroundDark;
  static const Color primaryLight = backgroundLight;

  // Semantic
  static const Color primaryAccentLight = Color(0xFF38BDF8);
  static const Color primaryRedLight = Color(0xFFEB6A5E);
  static const Color primaryYellowLight = Color(0xFFFDD663);
  static const Color primaryGreenLight = Color(0xFF46B565);

  // Text
  static const Color textPrimary = Color(0xFFE9EFFB);

  /// In-card paragraph text — dim prose so titles and figures pop.
  static const Color textBody = Color(0xFFB6C2D9);
  static const Color textSecondary = Color(0xFF8C9BB8);
  static const Color borderSubtle = Color(0x14FFFFFF);

  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF22D3EE),
    Color(0xFFA78BFA),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFA78BFA),
    Color(0xFF22D3EE),
  ];

  // Skill level colors
  static const Color beginnerLevel = Color(0xFFEB6A5E);
  static const Color intermediateLevel = Color(0xFFFDD663);
  static const Color advancedLevel = Color(0xFF38BDF8);
  static const Color expertLevel = Color(0xFF22D3EE);
}

class AppLayout {
  static const double maxContentWidth = 1200;

  /// Comfortable reading measure for paragraphs inside wide cards.
  static const double maxProseWidth = 760;
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 96);
}

/// Monospace accent type — eyebrows, indices, badges ("HUD" text).
class AppFonts {
  static TextStyle mono({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textSecondary,
    double letterSpacing = 2,
    double? height,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.accentPrimary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPrimary,
      secondary: AppColors.accentSecondary,
      tertiary: AppColors.accentTertiary,
      surface: AppColors.cardBackground,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -2,
        height: 1.05,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -1.5,
        height: 1.1,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -1,
        height: 1.15,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.25,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
        height: 1.65,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        letterSpacing: 0.1,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12.5,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 1.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.backgroundDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        side: BorderSide(
          color: AppColors.accentPrimary.withValues(alpha: 0.6),
          width: 1.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderSubtle,
      thickness: 1,
      space: 40,
    ),
  );
}
