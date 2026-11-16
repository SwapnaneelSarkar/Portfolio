import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "After-hours roadmap board" palette.
///
/// Accent colours are status colours, not decoration:
/// marigold = now / primary action, mint = shipped, lilac = research.
class AppColors {
  // Backgrounds
  static const Color backgroundDark = Color(0xFF0F0B24); // ink
  static const Color backgroundLight = Color(0xFF171233);
  static const Color cardBackground = Color(0xFF1A1538);
  static const Color cardHover = Color(0xFF221C47);
  static const Color cardActive = Color(0xFF2B2456);

  // Status accents
  static const Color marigold = Color(0xFFFFB23F);
  static const Color mint = Color(0xFF45E0A8);
  static const Color lilac = Color(0xFFB49CFF);
  static const Color coral = Color(0xFFFF8A70);

  static const Color now = marigold;
  static const Color shipped = mint;
  static const Color research = lilac;

  // Accents (kept for existing call sites)
  static const Color accentPrimary = marigold;
  static const Color accentSecondary = lilac;
  static const Color accentTertiary = mint;
  static const Color accentWarm = coral;
  static const Color accentPrimaryHover = Color(0xFFFFC266);

  // Names from the previous design language, kept so call sites compile.
  static const Color ink = backgroundDark;
  static const Color signal = marigold;
  static const Color ice = lilac;
  static const Color tape = mint;
  static const Color paper = textPrimary;

  // Legacy aliases for gradual migration
  static const Color primaryDark = backgroundDark;
  static const Color primaryLight = backgroundLight;

  // Semantic
  static const Color primaryAccentLight = lilac;
  static const Color primaryRedLight = Color(0xFFFF6B7A);
  static const Color primaryYellowLight = marigold;
  static const Color primaryGreenLight = mint;

  // Text
  static const Color textPrimary = Color(0xFFF3F0FF);
  static const Color textSecondary = Color(0xFFA9A2CB);

  /// In-card paragraph text — dimmer than titles so figures pop.
  static const Color textBody = Color(0xFFC9C3E6);
  static const Color textFaint = Color(0xFF746D9B);
  static const Color borderSubtle = Color(0x17FFFFFF);
  static const Color borderStrong = Color(0x2BFFFFFF);
  static const Color grid = Color(0x0EFFFFFF);
  static const Color gridMajor = Color(0x17FFFFFF);

  // Gradients
  static const List<Color> primaryGradient = [marigold, coral];
  static const List<Color> secondaryGradient = [lilac, Color(0xFF7C6CFF)];

  // Skill level colors
  static const Color beginnerLevel = coral;
  static const Color intermediateLevel = marigold;
  static const Color advancedLevel = lilac;
  static const Color expertLevel = mint;
}

class AppLayout {
  static const double maxContentWidth = 1200;

  /// Comfortable reading measure for paragraphs inside wide cards.
  static const double maxProseWidth = 720;
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 72);

  static const double mobileBreakpoint = 700;
  static const double tabletBreakpoint = 1000;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
  static bool isMobile(BuildContext context) =>
      width(context) < mobileBreakpoint;
  static bool isTablet(BuildContext context) =>
      width(context) >= mobileBreakpoint && width(context) < tabletBreakpoint;
  static bool isDesktop(BuildContext context) =>
      width(context) >= tabletBreakpoint;

  /// Horizontal page gutter for the current width.
  static double gutter(BuildContext context) => isMobile(context) ? 20 : 32;
}

/// Type roles: Unbounded for display, Instrument Sans for body,
/// JetBrains Mono for labels, dates and status.
class AppText {
  static TextStyle display({
    double size = 40,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double height = 1.08,
    double letterSpacing = -0.5,
  }) {
    return GoogleFonts.unbounded(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono({
    double size = 12,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.textSecondary,
    double letterSpacing = 0.6,
    double? height,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle body({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.6,
  }) {
    return GoogleFonts.instrumentSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }
}

/// Older type API, kept for existing call sites. Maps onto [AppText].
class AppFonts {
  static TextStyle mono({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.textSecondary,
    double letterSpacing = 1.2,
    double? height,
  }) =>
      AppText.mono(
        size: fontSize,
        weight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle display({
    double fontSize = 40,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double letterSpacing = -0.5,
    double height = 1.08,
  }) =>
      AppText.display(
        size: fontSize,
        weight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle body({
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textBody,
    double letterSpacing = 0,
    double height = 1.6,
  }) =>
      AppText.body(
        size: fontSize,
        weight: fontWeight,
        color: color,
        height: height,
      ).copyWith(letterSpacing: letterSpacing);
}

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    canvasColor: AppColors.backgroundDark,
    primaryColor: AppColors.accentPrimary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPrimary,
      onPrimary: AppColors.backgroundDark,
      secondary: AppColors.accentSecondary,
      onSecondary: AppColors.backgroundDark,
      tertiary: AppColors.accentTertiary,
      surface: AppColors.cardBackground,
      onSurface: AppColors.textPrimary,
    ),
    focusColor: AppColors.marigold.withValues(alpha: 0.18),
    hoverColor: Colors.white.withValues(alpha: 0.04),
    splashColor: AppColors.marigold.withValues(alpha: 0.08),
    highlightColor: Colors.transparent,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.marigold,
      selectionColor: AppColors.marigold.withValues(alpha: 0.3),
    ),
    textTheme: TextTheme(
      displayLarge: AppText.display(size: 72, weight: FontWeight.w800),
      displayMedium: AppText.display(size: 52, weight: FontWeight.w700),
      displaySmall: AppText.display(size: 38, weight: FontWeight.w600),
      headlineMedium: AppText.display(
        size: 28,
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3,
      ),
      headlineSmall: AppText.display(
        size: 22,
        weight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      titleLarge: AppText.body(size: 20, weight: FontWeight.w600, height: 1.3),
      titleMedium: AppText.body(size: 16, weight: FontWeight.w600, height: 1.4),
      titleSmall: AppText.body(size: 14, weight: FontWeight.w600, height: 1.4),
      bodyLarge: AppText.body(size: 16, height: 1.65),
      bodyMedium: AppText.body(
        size: 15,
        color: AppColors.textBody,
        height: 1.6,
      ),
      bodySmall: AppText.body(
        size: 12.5,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      labelLarge: AppText.body(size: 15, weight: FontWeight.w600, height: 1.2),
      labelMedium: AppText.mono(size: 12),
      labelSmall: AppText.mono(size: 11),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.marigold,
        foregroundColor: AppColors.backgroundDark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: const StadiumBorder(),
        textStyle: AppText.body(size: 15, weight: FontWeight.w600, height: 1),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.marigold,
        foregroundColor: AppColors.backgroundDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: const StadiumBorder(),
        textStyle: AppText.body(size: 15, weight: FontWeight.w600, height: 1),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderStrong),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: const StadiumBorder(),
        textStyle: AppText.body(size: 15, weight: FontWeight.w600, height: 1),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.marigold,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: const StadiumBorder(),
        textStyle: AppText.body(size: 15, weight: FontWeight.w600, height: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.03),
      hintStyle: AppText.body(size: 15, color: AppColors.textFaint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.marigold, width: 1.5),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.cardActive,
      contentTextStyle: AppText.body(size: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppText.body(size: 18, weight: FontWeight.w600),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 22,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderSubtle,
      thickness: 1,
      space: 40,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.cardActive,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      textStyle: AppText.mono(size: 11, color: AppColors.textPrimary),
    ),
  );
}
