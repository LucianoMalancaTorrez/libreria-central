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
  static const Color parchmentDeep = Color(
    0xFFEDE3CE,
  ); // fondo secundario / cards
  static const Color leather = Color(0xFF5C4033); // texto principal
  static const Color leatherDeep = Color(
    0xFF3B2A20,
  ); // texto de énfasis / headers
  static const Color bottleGreen = Color(0xFF0B6623); // acento primario
  static const Color bottleGreenDark = Color(0xFF07401A); // hover/pressed
  static const Color brass = Color(0xFFB08D57); // acento secundario / bordes
  static const Color navy = Color(0xFF1B2A4A); // acento alterno (links, info)
  static const Color error = Color(0xFF8B2E2E); // rojo óxido, no rojo puro
}

/// Colores que usan las pantallas. En el tema oscuro "papel" y "tinta" se
/// invierten, así cada combinación sigue teniendo contraste.
class Colores extends ThemeExtension<Colores> {
  const Colores({
    required this.parchment,
    required this.parchmentDeep,
    required this.leather,
    required this.leatherDeep,
    required this.bottleGreen,
    required this.bottleGreenDark,
    required this.brass,
    required this.navy,
    required this.error,
  });

  static const claro = Colores(
    parchment: AppColors.parchment,
    parchmentDeep: AppColors.parchmentDeep,
    leather: AppColors.leather,
    leatherDeep: AppColors.leatherDeep,
    bottleGreen: AppColors.bottleGreen,
    bottleGreenDark: AppColors.bottleGreenDark,
    brass: AppColors.brass,
    navy: AppColors.navy,
    error: AppColors.error,
  );

  static const oscuro = Colores(
    parchment: Color(0xFF1E1712),
    parchmentDeep: Color(0xFF2E241C),
    leather: Color(0xFFE6D8C3),
    leatherDeep: Color(0xFFF5EBDB),
    bottleGreen: Color(0xFF7FCB8F),
    bottleGreenDark: Color(0xFFA9E0B5),
    brass: Color(0xFFC9A56F),
    navy: Color(0xFFA9BCE8),
    error: Color(0xFFF2A0A0),
  );

  final Color parchment;
  final Color parchmentDeep;
  final Color leather;
  final Color leatherDeep;
  final Color bottleGreen;
  final Color bottleGreenDark;
  final Color brass;
  final Color navy;
  final Color error;

  @override
  Colores copyWith() => this;

  @override
  Colores lerp(covariant Colores? otro, double t) {
    if (otro == null) return this;
    return Colores(
      parchment: Color.lerp(parchment, otro.parchment, t)!,
      parchmentDeep: Color.lerp(parchmentDeep, otro.parchmentDeep, t)!,
      leather: Color.lerp(leather, otro.leather, t)!,
      leatherDeep: Color.lerp(leatherDeep, otro.leatherDeep, t)!,
      bottleGreen: Color.lerp(bottleGreen, otro.bottleGreen, t)!,
      bottleGreenDark: Color.lerp(bottleGreenDark, otro.bottleGreenDark, t)!,
      brass: Color.lerp(brass, otro.brass, t)!,
      navy: Color.lerp(navy, otro.navy, t)!,
      error: Color.lerp(error, otro.error, t)!,
    );
  }
}

extension ColoresDelTema on BuildContext {
  Colores get colores => Theme.of(this).extension<Colores>() ?? Colores.claro;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _construir(Colores.claro, ThemeData.light());

  static ThemeData get dark => _construir(Colores.oscuro, ThemeData.dark());

  static ThemeData _construir(Colores c, ThemeData base) {
    final textTheme = _buildTextTheme(base.textTheme, c);

    return base.copyWith(
      extensions: [c],
      scaffoldBackgroundColor: c.parchment,
      colorScheme: ColorScheme(
        brightness: base.brightness,
        primary: c.bottleGreen,
        onPrimary: c.parchment,
        secondary: c.brass,
        onSecondary: c.leatherDeep,
        surface: c.parchmentDeep,
        onSurface: c.leather,
        error: c.error,
        onError: c.parchment,
        tertiary: c.navy,
      ),
      textTheme: textTheme,

      // --- AppBar: como el header del wireframe, cálido y con el logo centrado ---
      appBarTheme: AppBarTheme(
        backgroundColor: c.parchment,
        foregroundColor: c.leatherDeep,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: c.leatherDeep),
        iconTheme: IconThemeData(color: c.leather),
      ),

      // --- Cards: tarjetas de libro con "sello" sutil en el borde ---
      cardTheme: CardThemeData(
        color: c.parchmentDeep,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: c.brass.withValues(alpha: 0.55), width: 1.2),
        ),
      ),

      // --- Botones de sección tipo "píldora" ---
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.brass.withValues(alpha: 0.35),
          foregroundColor: c.leatherDeep,
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.bottleGreen,
          foregroundColor: c.parchment,
          disabledBackgroundColor: c.bottleGreen.withValues(alpha: 0.4),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ).copyWith(overlayColor: WidgetStateProperty.all(c.bottleGreenDark)),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.leatherDeep,
          side: BorderSide(color: c.leather, width: 1.4),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.navy,
          textStyle: textTheme.labelLarge,
        ),
      ),

      // --- Buscador de catálogo ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.parchmentDeep,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: c.leather.withValues(alpha: 0.55),
        ),
        prefixIconColor: c.leather,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: c.brass.withValues(alpha: 0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: c.brass.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: c.bottleGreen, width: 1.6),
        ),
      ),

      // --- Chips: útiles para género, filtros del catálogo ---
      chipTheme: ChipThemeData(
        backgroundColor: c.parchment,
        selectedColor: c.bottleGreen.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.specialElite(
          fontSize: 12,
          letterSpacing: 0.5,
          color: c.leatherDeep,
        ),
        side: BorderSide(color: c.brass.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      dividerTheme: DividerThemeData(
        color: c.brass.withValues(alpha: 0.4),
        thickness: 1,
        space: 32,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.parchmentDeep,
        selectedItemColor: c.bottleGreen,
        unselectedItemColor: c.leather.withValues(alpha: 0.5),
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      iconTheme: IconThemeData(color: c.leather),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Colores c) {
    final display = GoogleFonts.playfairDisplayTextTheme(base);
    final body = GoogleFonts.loraTextTheme(base);

    return body.copyWith(
      displayLarge: display.displayLarge?.copyWith(
        color: c.leatherDeep,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        color: c.leatherDeep,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        color: c.leatherDeep,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: display.titleLarge?.copyWith(
        color: c.leatherDeep,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: display.titleMedium?.copyWith(
        color: c.leather,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: body.bodyLarge?.copyWith(color: c.leather),
      bodyMedium: body.bodyMedium?.copyWith(color: c.leather),
      labelLarge: body.labelLarge?.copyWith(
        color: c.leather,
        fontWeight: FontWeight.w600,
      ),
      // Rol utilitario "máquina de escribir" para sellos/etiquetas cortas
      labelSmall: GoogleFonts.specialElite(
        fontSize: 11,
        letterSpacing: 0.6,
        color: c.leather.withValues(alpha: 0.8),
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
