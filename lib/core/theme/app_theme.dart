import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary colors
  static const Color primaryDark = Color(0xFF0A0E21);
  static const Color primaryLight = Color(0xFF1A1F38);
  
  // Accent colors
  static const Color accentPrimary = Color(0xFF6C63FF);  // Purple
  static const Color accentSecondary = Color(0xFF00D9F5); // Cyan
  static const Color accentTertiary = Color(0xFFFF5757);  // Red
  
  // Text colors
  static const Color primaryAccentLight = Color(0xFF5E97F6);
  static const Color primaryRedLight = Color(0xFFEB6A5E);
  static const Color primaryYellowLight = Color(0xFFFDD663);
  static const Color primaryGreenLight = Color(0xFF46B565);
  
  // Background colors
  static const Color backgroundDark = Color(0xFF202124);  // Google Dark Gray
  static const Color backgroundLight = Color(0xFF303134); // Google Light Gray
  static const Color cardBackground = Color(0xFF3C4043);  // Google Card Gray
  static const Color cardHover = Color(0xFF4A4E52);      // Hover state
  static const Color cardActive = Color(0xFF5A5E62);     // Active state
  
  // Text colors
  static const Color textPrimary = Color(0xFFE8EAED);    // Google Light Text
  static const Color textSecondary = Color(0xFF9AA0A6);  // Google Secondary Text
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF00D9F5),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF00D9F5),
    Color(0xFF6C63FF),
  ];
  
  // Skill level colors
  static const Color beginnerLevel = Color(0xFFFF5757);  // Red for beginner
  static const Color intermediateLevel = Color(0xFFFDD663);  // Yellow for intermediate
  static const Color advancedLevel = Color(0xFF00D9F5);  // Cyan for advanced
  static const Color expertLevel = Color(0xFF6C63FF);  // Purple for expert
}

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.accentPrimary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPrimary,
      secondary: AppColors.accentSecondary,
      background: AppColors.backgroundDark,
      surface: AppColors.cardBackground,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 56,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.25,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        letterSpacing: 0.25,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 1.25,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        side: const BorderSide(color: AppColors.accentPrimary, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
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
      color: AppColors.textSecondary,
      thickness: 1,
      space: 40,
    ),
  );
}
