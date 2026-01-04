import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Colors ---
  static const _primaryColor = Color(0xFFD946EF); // Neon Pink/Purple
  static const _secondaryColor = Color(0xFF8B5CF6); // Violet
  static const _tertiaryColor = Color(0xFF0EA5E9); // Sky Blue
  static const _backgroundColor = Color(0xFF0F172A); // Dark Slate
  static const _surfaceColor = Color(0xFF1E293B); // Darker Blue Grey
  static const _errorColor = Color(0xFFEF4444);

  // --- Text Theme ---
  static TextTheme _textTheme(ColorScheme colorScheme) {
    // 日本語フォントとして M PLUS Rounded 1c を使用 (なければ Noto Sans 等にフォールバック)
    // Google Fontsのエラーハンドリングを考慮し、まずは標準的な設定
    final baseTextTheme = GoogleFonts.mPlusRounded1cTextTheme();

    return baseTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
      decorationColor: colorScheme.onSurface,
    );
  }

  // --- Dark Theme (Main) ---
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: _primaryColor,
      onPrimary: Colors.white,
      secondary: _secondaryColor,
      onSecondary: Colors.white,
      tertiary: _tertiaryColor,
      surface: _surfaceColor,
      onSurface: Colors.white,
      surfaceContainerHighest: Color(0xFF334155), // 薄めの背景 (Card等)
      error: _errorColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _backgroundColor,
      textTheme: _textTheme(colorScheme),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.mPlusRounded1c(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _surfaceColor,
        elevation: 4,
        shadowColor: _primaryColor.withValues(alpha: 0.4), // ネオンっぽい影
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: _primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        extendedTextStyle: GoogleFonts.mPlusRounded1c(
          fontWeight: FontWeight.bold,
        ),
      ),

      // Input Decoration (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF334155),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.white70),
        hintStyle: TextStyle(color: Colors.white38),
        prefixIconColor: Colors.white70,
      ),

      // Chips (FilterChip etc)
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceColor,
        labelStyle: TextStyle(color: Colors.white),
        selectedColor: _primaryColor,
        secondarySelectedColor: _primaryColor,
        side: BorderSide(color: _primaryColor.withValues(alpha: 0.5)),
        shape: StadiumBorder(),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.mPlusRounded1c(fontWeight: FontWeight.bold),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // --- Light Theme (Optional / Fallback) ---
  // 基本はダークモード推奨だが、ライトモードも一応定義
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.mPlusRounded1cTextTheme(),
    );
  }
}
