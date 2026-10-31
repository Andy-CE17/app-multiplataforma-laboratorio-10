import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NovaColors {
  static const background = Color(0xFF020A19);
  static const surface = Color(0xFF081528);
  static const card = Color(0xFF0D1A31);
  static const cyan = Color(0xFF20C5FF);
  static const blue = Color(0xFF3478FF);
  static const violet = Color(0xFF9B3DFF);
  static const pink = Color(0xFFFF2367);
  static const textMuted = Color(0xFF9CA9C1);
  static const border = Color(0xFF1D3C65);
}

class AppTheme {
  static ThemeData lightTheme() {
    return darkTheme().copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF2F5FB),
      colorScheme: ColorScheme.fromSeed(
        seedColor: NovaColors.blue,
        brightness: Brightness.light,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0x3320C5FF),
        labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11)),
      ),
    );
  }

  static ThemeData darkTheme() {
    final textTheme = GoogleFonts.spaceGroteskTextTheme(
      ThemeData.dark().textTheme,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NovaColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NovaColors.cyan,
        brightness: Brightness.dark,
        primary: NovaColors.cyan,
        secondary: NovaColors.violet,
        surface: NovaColors.surface,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NovaColors.card.withValues(alpha: .92),
        hintStyle: const TextStyle(color: NovaColors.textMuted),
        prefixIconColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: NovaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: NovaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: NovaColors.cyan, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: NovaColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF061226),
        indicatorColor: Color(0x3320C5FF),
        labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11)),
      ),
    );
  }
}
