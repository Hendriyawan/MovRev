import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF00E5FF);
  static const secondary = Color(0xFFFFD700);

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final neutral = isDark ? const Color(0xFFFAFAFA) : const Color(0xFF05070A);
    final background = isDark
        ? const Color(0xFF191c1f)
        : const Color(0xFFF5EFE6);
    final surface = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFBF7F0);
    final inputFill = isDark ? const Color(0xFF2C2C2C) : Colors.white;

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      surface: surface,
    );

    // Helper wrappers
    TextStyle manrope(TextStyle base) => GoogleFonts.manrope(textStyle: base);
    TextStyle plusJakarta(TextStyle base) =>
        GoogleFonts.plusJakartaSans(textStyle: base);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: TextTheme(
        // ── Display / Headline → Manrope ──────────────────────────────
        displaySmall: manrope(
          TextStyle(
            fontSize: 38,
            height: 1.06,
            fontWeight: FontWeight.w700,
            color: neutral,
          ),
        ),
        headlineMedium: manrope(
          TextStyle(
            fontSize: 24,
            height: 1.15,
            fontWeight: FontWeight.w700,
            color: neutral,
          ),
        ),
        // ── Title → Manrope ───────────────────────────────────────────
        titleLarge: manrope(
          TextStyle(
            fontSize: 20,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: neutral,
          ),
        ),
        titleMedium: manrope(
          TextStyle(
            fontSize: 16,
            height: 1.25,
            fontWeight: FontWeight.w700,
            color: neutral,
          ),
        ),
        titleSmall: manrope(
          TextStyle(
            fontSize: 14,
            height: 1.3,
            fontWeight: FontWeight.w600,
            color: neutral,
          ),
        ),
        // ── Body → Manrope ────────────────────────────────────────────
        bodyLarge: manrope(
          TextStyle(
            fontSize: 15,
            height: 1.45,
            color: neutral.withValues(alpha: 0.8),
          ),
        ),
        bodyMedium: manrope(
          TextStyle(
            fontSize: 14,
            height: 1.45,
            color: neutral.withValues(alpha: 0.7),
          ),
        ),
        bodySmall: manrope(
          TextStyle(
            fontSize: 12,
            height: 1.4,
            color: neutral.withValues(alpha: 0.6),
          ),
        ),
        // ── Label → Plus Jakarta Sans ─────────────────────────────────
        labelLarge: plusJakarta(
          TextStyle(
            fontSize: 13,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w700,
            color: isDark ? neutral : Colors.white,
          ),
        ),
        labelMedium: plusJakarta(
          TextStyle(
            fontSize: 12,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w600,
            color: neutral.withValues(alpha: 0.8),
          ),
        ),
        labelSmall: plusJakarta(
          TextStyle(
            fontSize: 11,
            letterSpacing: 0.2,
            fontWeight: FontWeight.w500,
            color: neutral.withValues(alpha: 0.6),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: secondary.withValues(alpha: 0.18),
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: inputFill,
        selectedColor: secondary.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: neutral.withValues(alpha: 0.08)),
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          textStyle: TextStyle(color: neutral, fontWeight: FontWeight.w700),
        ),
        side: BorderSide(color: neutral.withValues(alpha: 0.08)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        hintStyle: GoogleFonts.manrope(
          textStyle: TextStyle(color: neutral.withValues(alpha: 0.6)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: neutral.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: neutral,
        contentTextStyle: GoogleFonts.manrope(
          textStyle: TextStyle(color: background),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      cardTheme: CardThemeData(
        color: surface,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }
}
