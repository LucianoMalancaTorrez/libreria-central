// app_theme.dart
// Identidad visual "vintage" para la app de la librería.
// Requiere el paquete google_fonts en pubspec.yaml:
//
// dependencies:
//   google_fonts: ^6.2.1
//
// Uso en main.dart:
//   MaterialApp(theme: AppTheme.light, ...)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de la librería: tonos de papel envejecido, cuero y latón.
class AppColors {
  AppColors._();

  static const Color parchment = Color(0xFFF5F2EB); // fondo principal
  static const Color parchmentDeep = Color(0xFFEDE3CE); // fondo secundario / cards
  static const Color leather = Color(0xFF5C4033); // texto principal
  static const Color leatherDeep = Color(0xFF3B2A20); // texto de énfasis / headers
  static const Color bottleGreen = Color(0xFF0B6623); // acento primario
  static const Color bottleGreenDark = Color(0xFF07401A); // hover/pressed
  static const Color brass = Color(0xFFB08D57); // acento secundario / bordes
  static const Color navy = Color(0xFF1B2A4A); // acento alterno (links, info)
  static const Color error = Color(0xFF8B2E2E); // rojo óxido, no rojo puro
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light();
    final textTheme = _buildTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.parchment,
      colorScheme: const ColorScheme.light(
        primary: AppColors.bottleGreen,
        onPrimary: AppColors.parchment,
        secondary: AppColors.brass,
        onSecondary: AppColors.leatherDeep,
        surface: AppColors.parchmentDeep,
        onSurface: AppColors.leather,
        error: AppColors.error,
        onError: AppColors.parchment,
        tertiary: AppColors.navy,
      ),
      textTheme: textTheme,

      // --- AppBar: como el header del wireframe, cálido y con el logo centrado ---
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.parchment,
        foregroundColor: AppColors.leatherDeep,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.leatherDeep,
        ),
        iconTheme: const IconThemeData(color: AppColors.leather),
      ),

      // --- Cards: tarjetas de libro con "sello" sutil en el borde ---
      cardTheme: CardThemeData(
        color: AppColors.parchmentDeep,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: AppColors.brass.withValues(alpha: 0.55), width: 1.2),
        ),
      ),

      // --- Botones de sección tipo "píldora" ---
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brass.withValues(alpha: 0.35),
          foregroundColor: AppColors.leatherDeep,
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 0,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bottleGreen,
          foregroundColor: AppColors.parchment,
          disabledBackgroundColor: AppColors.bottleGreen.withValues(alpha: 0.4),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ).copyWith(
          overlayColor: WidgetStateProperty.all(AppColors.bottleGreenDark),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.leatherDeep,
          side: const BorderSide(color: AppColors.leather, width: 1.4),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          textStyle: textTheme.labelLarge,
        ),
      ),

      // --- Buscador de catálogo ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.parchmentDeep,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.leather.withValues(alpha: 0.55),
        ),
        prefixIconColor: AppColors.leather,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.brass.withValues(alpha: 0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.brass.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.bottleGreen, width: 1.6),
        ),
      ),

      // --- Chips: útiles para género, filtros del catálogo ---
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.parchment,
        selectedColor: AppColors.bottleGreen.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.specialElite(
          fontSize: 12,
          letterSpacing: 0.5,
          color: AppColors.leatherDeep,
        ),
        side: BorderSide(color: AppColors.brass.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.brass.withValues(alpha: 0.4),
        thickness: 1,
        space: 32,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.parchmentDeep,
        selectedItemColor: AppColors.bottleGreen,
        unselectedItemColor: AppColors.leather.withValues(alpha: 0.5),
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      iconTheme: const IconThemeData(color: AppColors.leather),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    final display = GoogleFonts.playfairDisplayTextTheme(base);
    final body = GoogleFonts.loraTextTheme(base);

    return body.copyWith(
      displayLarge: display.displayLarge?.copyWith(
        color: AppColors.leatherDeep,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        color: AppColors.leatherDeep,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        color: AppColors.leatherDeep,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: display.titleLarge?.copyWith(
        color: AppColors.leatherDeep,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: display.titleMedium?.copyWith(
        color: AppColors.leather,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: body.bodyLarge?.copyWith(color: AppColors.leather),
      bodyMedium: body.bodyMedium?.copyWith(color: AppColors.leather),
      labelLarge: body.labelLarge?.copyWith(
        color: AppColors.leather,
        fontWeight: FontWeight.w600,
      ),
      // Rol utilitario "máquina de escribir" para sellos/etiquetas cortas
      labelSmall: GoogleFonts.specialElite(
        fontSize: 11,
        letterSpacing: 0.6,
        color: AppColors.leather.withValues(alpha: 0.8),
      ),
    );
  }

  /// Estilo puntual para sellos/etiquetas tipo "EN STOCK" o credenciales.
  static TextStyle stampLabel({Color color = AppColors.leatherDeep}) {
    return GoogleFonts.specialElite(
      fontSize: 12,
      letterSpacing: 0.8,
      color: color,
    );
  }
}
