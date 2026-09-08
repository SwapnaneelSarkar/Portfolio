import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens — "software light over an industrial world".
///
/// Ground is a deep blueprint navy, text is warm waybill paper, the primary
/// accent is safety orange (actions, routes, active states) and a cool ice
/// blue marks the AI/data layer. Identifier names are kept stable so call
/// sites compile; the values are the design.
class AppColors {
  // Ground
  static const Color backgroundDark = Color(0xFF0B1020);
  static const Color backgroundLight = Color(0xFF0F1628);
  static const Color cardBackground = Color(0xFF111A2E);
  static const Color cardHover = Color(0xFF16213A);
  static const Color cardActive = Color(0xFF1B2846);

  // Accents — signal orange / ice blue / tape amber
  static const Color accentPrimary = Color(0xFFFF6B2C);
  static const Color accentSecondary = Color(0xFF7FDBFF);
  static const Color accentTertiary = Color(0xFFFFC531);
  static const Color accentWarm = Color(0xFFFFC531);

  /// Hover state of the primary accent (a touch brighter).
  static const Color accentPrimaryHover = Color(0xFFFF7F48);

  // Named aliases that read like the design language.
  static const Color ink = backgroundDark;
  static const Color signal = accentPrimary;
  static const Color ice = accentSecondary;
  static const Color tape = accentTertiary;
  static const Color paper = textPrimary;

  // Legacy aliases
  static const Color primaryDark = backgroundDark;
  static const Color primaryLight = backgroundLight;

  // Semantic
  static const Color primaryAccentLight = Color(0xFF7FDBFF);
  static const Color primaryRedLight = Color(0xFFFF6B2C);
  static const Color primaryYellowLight = Color(0xFFFFC531);
  static const Color primaryGreenLight = Color(0xFF5FD3A1);

  // Text
  static const Color textPrimary = Color(0xFFF3EFE7);

  /// In-card paragraph text — dim prose so titles and figures pop.
  static const Color textBody = Color(0xFFC3C9D6);
  static const Color textSecondary = Color(0xFF8E9BB3);
  static const Color borderSubtle = Color(0x14FFFFFF);

  /// Blueprint grid lines (minor / major).
  static const Color grid = Color(0x0AFFFFFF);
  static const Color gridMajor = Color(0x14FFFFFF);

  // Gradients — warm only, reserved for the primary button and hairlines.
  static const List<Color> primaryGradient = [
    Color(0xFFFF6B2C),
    Color(0xFFFF9A5C),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF7FDBFF),
    Color(0xFFFF6B2C),
  ];

  // Skill level colors
  static const Color beginnerLevel = Color(0xFFFF6B2C);
  static const Color intermediateLevel = Color(0xFFFFC531);
  static const Color advancedLevel = Color(0xFF7FDBFF);
  static const Color expertLevel = Color(0xFFF3EFE7);
}

class AppLayout {
  static const double maxContentWidth = 1200;

  /// Comfortable reading measure for paragraphs inside wide cards.
  static const double maxProseWidth = 720;
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 104);

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
  static double gutter(BuildContext context) => isMobile(context) ? 20 : 48;
}

/// Type roles.
///
/// Display = Big Shoulders Display (condensed industrial caps, used with
/// restraint), body = IBM Plex Sans, data/utility = IBM Plex Mono.
class AppFonts {
  /// Mono utility text — eyebrows, record keys, indices, badges.
  static TextStyle mono({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.textSecondary,
    double letterSpacing = 1.6,
    double? height,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Condensed display caps. Callers pass uppercase strings.
  static TextStyle display({
    double fontSize = 44,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double letterSpacing = 1,
    double height = 1.0,
  }) {
    return GoogleFonts.bigShouldersDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle body({
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textBody,
    double letterSpacing = 0,
    double height = 1.6,
  }) {
    return GoogleFonts.ibmPlexSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

class AppTheme {
  static const double _radius = 6;
  static const double _cardRadius = 10;

  static final TextStyle _buttonText = GoogleFonts.ibmPlexSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.accentPrimary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    canvasColor: AppColors.backgroundDark,
    hoverColor: Colors.white.withValues(alpha: 0.04),
    focusColor: AppColors.accentSecondary.withValues(alpha: 0.18),
    splashFactory: InkRipple.splashFactory,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPrimary,
      onPrimary: AppColors.backgroundDark,
      secondary: AppColors.accentSecondary,
      onSecondary: AppColors.backgroundDark,
      tertiary: AppColors.accentTertiary,
      surface: AppColors.cardBackground,
      onSurface: AppColors.textPrimary,
      outline: AppColors.borderSubtle,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.bigShouldersDisplay(
        fontSize: 112,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 1,
        height: 0.92,
      ),
      displayMedium: GoogleFonts.bigShouldersDisplay(
        fontSize: 72,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 1,
        height: 0.95,
      ),
      displaySmall: GoogleFonts.bigShouldersDisplay(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 1,
        height: 1.0,
      ),
      headlineMedium: GoogleFonts.bigShouldersDisplay(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.8,
        height: 1.05,
      ),
      headlineSmall: GoogleFonts.ibmPlexSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.ibmPlexSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.1,
        height: 1.3,
      ),
      titleMedium: GoogleFonts.ibmPlexSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
      titleSmall: GoogleFonts.ibmPlexSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0,
      ),
      bodyLarge: GoogleFonts.ibmPlexSans(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        letterSpacing: 0,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.ibmPlexSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textBody,
        letterSpacing: 0,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.ibmPlexSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.ibmPlexMono(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        letterSpacing: 1.6,
      ),
      labelMedium: GoogleFonts.ibmPlexMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 1.6,
      ),
      labelSmall: GoogleFonts.ibmPlexMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 1.4,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: AppColors.backgroundDark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        textStyle: _buttonText,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? Colors.white.withValues(alpha: 0.10)
              : null,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderSubtle),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        textStyle: _buttonText,
      ).copyWith(
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.focused)
                ? AppColors.accentPrimary
                : AppColors.borderSubtle,
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        textStyle: _buttonText,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: GoogleFonts.ibmPlexMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
        color: AppColors.textSecondary,
      ),
      hintStyle: GoogleFonts.ibmPlexSans(
        fontSize: 15,
        color: AppColors.textSecondary.withValues(alpha: 0.7),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(
          color: AppColors.accentSecondary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.accentPrimary),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.bigShouldersDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: AppColors.textPrimary,
      ),
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
        color: AppColors.cardHover,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      textStyle: GoogleFonts.ibmPlexMono(
        fontSize: 11,
        color: AppColors.textPrimary,
        letterSpacing: 1,
      ),
    ),
  );
}
