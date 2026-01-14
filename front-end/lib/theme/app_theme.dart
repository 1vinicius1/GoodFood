import 'package:flutter/material.dart';

class AppTheme {
  // Base “cinza fosco” do protótipo
  static const _bg = Color(0xFF1E1E1E);        // fundo geral (grafite)
  static const _panel = Color(0xFF3C3C3C);     // painel/card grande
  static const _surface = Color(0xFF343434);   // inputs/superfícies
  static const _surface2 = Color(0xFF424242);  // variação pra cards

  static const _text = Color(0xFFF2F2F2);      // branco suave
  static const _muted = Color(0xFFB7B7B7);     // texto secundário

  // Accent “Food / underline / FAB”
  static const _accent = Color(0xFFCE4E32);    // laranja-avermelhado queimado
  static const _accentDarkText = Color(0xFF1A1A1A);

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: _bg,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: _accent,
        secondary: _accent,
        surface: _surface,
      ),

      // Ajuda a padronizar “cinza fosco” em vários widgets
      cardColor: _surface2,

      textTheme: base.textTheme.apply(
        bodyColor: _text,
        displayColor: _text,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: _text,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        hintStyle: const TextStyle(color: _muted),
        labelStyle: const TextStyle(color: _muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _accent, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: _accentDarkText,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _muted,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      cardTheme: CardThemeData(
        color: _panel, // mais “painel” igual ao protótipo
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      dividerTheme: const DividerThemeData(color: Color(0xFF4A4A4A)),
    );
  }

  static ThemeData get light => ThemeData.light(useMaterial3: true);
}
