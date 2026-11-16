import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colour tokens for the workspace UI, in a light and a dark variant.
///
/// Status colours mean the same thing everywhere: [shipped] is done,
/// [progress] is ongoing, [docs] marks written work. [accent] is reserved for
/// "you are here" moments: the active nav item, today on the roadmap, focus.
@immutable
class Palette extends ThemeExtension<Palette> {
  final Brightness brightness;

  /// Window chrome behind the sidebar and main panel.
  final Color frame;

  /// The main panel and cards.
  final Color surface;

  /// Inset areas: inputs, group headers, image wells.
  final Color sunken;
  final Color hover;
  final Color selected;
  final Color border;
  final Color borderStrong;

  final Color text;
  final Color textMuted;
  final Color textFaint;

  /// Primary buttons are ink-on-paper, not a brand colour.
  final Color primary;
  final Color onPrimary;

  final Color accent;
  final Color shipped;
  final Color progress;
  final Color docs;
  final Color info;
  final Color danger;

  const Palette({
    required this.brightness,
    required this.frame,
    required this.surface,
    required this.sunken,
    required this.hover,
    required this.selected,
    required this.border,
    required this.borderStrong,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.shipped,
    required this.progress,
    required this.docs,
    required this.info,
    required this.danger,
  });

  static const light = Palette(
    brightness: Brightness.light,
    frame: Color(0xFFF1F2F4),
    surface: Color(0xFFFFFFFF),
    sunken: Color(0xFFF6F7F9),
    hover: Color(0xFFF0F1F4),
    selected: Color(0xFFE5E7EC),
    border: Color(0xFFE3E5E9),
    borderStrong: Color(0xFFCDD0D7),
    text: Color(0xFF16181D),
    textMuted: Color(0xFF5B616D),
    textFaint: Color(0xFF8B909B),
    primary: Color(0xFF16181D),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFE4531B),
    shipped: Color(0xFF17955A),
    progress: Color(0xFFC88A04),
    docs: Color(0xFF6D55CF),
    info: Color(0xFF2E6AD8),
    danger: Color(0xFFD23B3B),
  );

  static const dark = Palette(
    brightness: Brightness.dark,
    frame: Color(0xFF0B0C0E),
    surface: Color(0xFF141519),
    sunken: Color(0xFF191B20),
    hover: Color(0xFF1E2026),
    selected: Color(0xFF25282F),
    border: Color(0xFF25272D),
    borderStrong: Color(0xFF34373F),
    text: Color(0xFFEBECEF),
    textMuted: Color(0xFFA0A5AF),
    textFaint: Color(0xFF6D727D),
    primary: Color(0xFFEBECEF),
    onPrimary: Color(0xFF141519),
    accent: Color(0xFFFF7A3D),
    shipped: Color(0xFF3CCB86),
    progress: Color(0xFFEDB23B),
    docs: Color(0xFF9F8AF2),
    info: Color(0xFF6E9DFF),
    danger: Color(0xFFFF6B6B),
  );

  bool get isDark => brightness == Brightness.dark;

  /// Background tint for a coloured badge or bar.
  Color tint(Color c) => c.withValues(alpha: isDark ? 0.18 : 0.11);

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(Palette? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

extension PaletteContext on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}

/// Bricolage Grotesque for page titles only, IBM Plex Sans for the interface,
/// IBM Plex Mono for dates, counts and keyboard hints.
class AppText {
  static TextStyle display({
    double size = 40,
    FontWeight weight = FontWeight.w700,
    Color? color,
    double height = 1.05,
    double letterSpacing = -1,
  }) {
    return GoogleFonts.bricolageGrotesque(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle ui({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double height = 1.45,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.ibmPlexSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono({
    double size = 12,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double letterSpacing = 0,
    double? height,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

class AppLayout {
  /// Below this the sidebar becomes a drawer.
  static const double sidebarBreakpoint = 1024;

  /// Below this the app gets a bottom tab bar.
  static const double mobileBreakpoint = 720;

  static const double sidebarWidth = 248;
  static const double topBarHeight = 52;
  static const double maxContentWidth = 1080;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
  static bool hasSidebar(BuildContext context) =>
      width(context) >= sidebarBreakpoint;
  static bool isMobile(BuildContext context) =>
      width(context) < mobileBreakpoint;

  static double gutter(BuildContext context) => isMobile(context) ? 16 : 40;
}

class AppTheme {
  static ThemeData get light => _build(Palette.light);
  static ThemeData get dark => _build(Palette.dark);

  static ThemeData _build(Palette p) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: p.accent,
        brightness: p.brightness,
      ).copyWith(
        primary: p.primary,
        onPrimary: p.onPrimary,
        secondary: p.accent,
        surface: p.surface,
        onSurface: p.text,
        error: p.danger,
        outline: p.borderStrong,
        outlineVariant: p.border,
      ),
    );

    final textTheme = GoogleFonts.ibmPlexSansTextTheme(base.textTheme).apply(
      bodyColor: p.text,
      displayColor: p.text,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
    final buttonText = AppText.ui(size: 13.5, weight: FontWeight.w500);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 10);

    return base.copyWith(
      scaffoldBackgroundColor: p.frame,
      canvasColor: p.surface,
      dividerColor: p.border,
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      hoverColor: p.hover,
      focusColor: p.accent.withValues(alpha: 0.14),
      highlightColor: Colors.transparent,
      extensions: [p],
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: p.textMuted, size: 18),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          minimumSize: const Size(0, 36),
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: buttonText,
        ).copyWith(
          overlayColor: WidgetStatePropertyAll(
            p.onPrimary.withValues(alpha: 0.1),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.text,
          backgroundColor: p.surface,
          minimumSize: const Size(0, 36),
          padding: buttonPadding,
          shape: buttonShape,
          side: BorderSide(color: p.borderStrong),
          textStyle: buttonText,
        ).copyWith(
          overlayColor: WidgetStatePropertyAll(p.hover),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.textMuted,
          minimumSize: const Size(0, 32),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: buttonShape,
          textStyle: buttonText,
        ).copyWith(
          overlayColor: WidgetStatePropertyAll(p.hover),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: p.textMuted,
          minimumSize: const Size(34, 34),
          padding: const EdgeInsets.all(8),
          iconSize: 18,
          shape: buttonShape,
        ).copyWith(
          overlayColor: WidgetStatePropertyAll(p.hover),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.sunken,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        hintStyle: AppText.ui(size: 14, color: p.textFaint),
        errorStyle: AppText.ui(size: 12, color: p.danger),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: p.danger, width: 1.5),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.accent,
        selectionColor: p.accent.withValues(alpha: 0.25),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 350),
        textStyle: AppText.ui(size: 12, color: p.isDark ? p.frame : Colors.white),
        decoration: BoxDecoration(
          color: p.isDark ? p.text : const Color(0xFF16181D),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.isDark ? p.text : const Color(0xFF16181D),
        contentTextStyle: AppText.ui(
          size: 13.5,
          color: p.isDark ? p.frame : Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        width: 420,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(6),
        thumbColor: WidgetStatePropertyAll(p.borderStrong),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: p.frame,
        shape: const RoundedRectangleBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.borderStrong,
      ),
    );
  }
}

/// Arcade palette for the hidden games, which keep their own dark look.
class AppColors {
  static const Color backgroundDark = Color(0xFF0F0B24);
  static const Color backgroundLight = Color(0xFF171233);
  static const Color cardBackground = Color(0xFF1A1538);
  static const Color accentPrimary = Color(0xFFFFB23F);
  static const Color accentSecondary = Color(0xFFB49CFF);
  static const Color accentTertiary = Color(0xFF45E0A8);
  static const Color textPrimary = Color(0xFFF3F0FF);
  static const Color textSecondary = Color(0xFFA9A2CB);
  static const Color borderSubtle = Color(0x17FFFFFF);
  static const List<Color> primaryGradient = [
    accentPrimary,
    Color(0xFFFF8A70),
  ];
}
