import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Elegant Wedding Palette — Luxury Minimal
class WeddingTheme {
  // Core palette — مستوحاة من موقع الدعوة الأصلي
  static const Color gold = Color(0xFFC9A66B);
  static const Color goldLight = Color(0xFFE8D5B5);
  static const Color goldDark = Color(0xFF9C7A3C);
  static const Color brown = Color(0xFF6B4F3B);
  static const Color brownDark = Color(0xFF4A3526);
  static const Color ivory = Color(0xFFFDF7F2);
  static const Color ivoryDark = Color(0xFFF5EBE0);
  static const Color cream = Color(0xFFFFFBF7);
  static const Color cardWhite = Colors.white;
  static const Color attendGreen = Color(0xFF6B8F7B);
  static const Color declineRose = Color(0xFFC98B8B);
  static const Color pendingGrey = Color(0xFFB0A99F);
  static const Color textDark = Color(0xFF2B241E);
  static const Color textMid = Color(0xFF6B5D52);
  static const Color textLight = Color(0xFF9A8E85);
  static const Color divider = Color(0xFFEEE6DC);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ivory,
      colorScheme: const ColorScheme.light(
        primary: gold,
        secondary: brown,
        surface: cardWhite,
        background: ivory,
        error: declineRose,
      ),
    );

    final cairo = GoogleFonts.cairoTextTheme(base.textTheme);
    final playfair = GoogleFonts.playfairDisplayTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: cairo.copyWith(
        displayLarge: playfair.displayLarge?.copyWith(color: textDark, fontWeight: FontWeight.w700, letterSpacing: -0.5) ??
            const TextStyle(color: textDark, fontWeight: FontWeight.w700),
        headlineLarge: cairo.headlineLarge?.copyWith(color: textDark, fontWeight: FontWeight.w800, fontSize: 26),
        titleLarge: cairo.titleLarge?.copyWith(color: textDark, fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ivory,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: textDark),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: goldDark,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        showUnselectedLabels: true,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ivoryDark,
        selectedColor: gold,
        labelStyle: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        side: const BorderSide(color: divider),
      ),
    );
  }

  // Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 8)),
        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
      ];
  static List<BoxShadow> get goldShadow => [
        BoxShadow(color: gold.withOpacity(0.18), blurRadius: 20, offset: const Offset(0, 8)),
      ];

  static LinearGradient get goldGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD7B98E), gold, goldDark],
      );

  static LinearGradient get softIvoryGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [cream, ivory, ivoryDark.withOpacity(0.5)],
      );
}
