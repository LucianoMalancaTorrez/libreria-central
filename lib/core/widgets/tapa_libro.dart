import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/models/libro.dart';

/// Foto de la tapa si la hay; si no, un ícono de libro.
class TapaLibro extends StatelessWidget {
  const TapaLibro({super.key, required this.libro, this.tamanoIcono = 32});

  final Libro libro;
  final double tamanoIcono;

  @override
  Widget build(BuildContext context) {
    final icono = Icon(
      Icons.menu_book_rounded,
      size: tamanoIcono,
      color: AppColors.leather,
    );
    if (libro.foto.isEmpty) return icono;
    return Image.memory(
      base64Decode(libro.foto),
      fit: BoxFit.contain,
      gaplessPlayback: true,
      semanticLabel: 'Tapa de ${libro.titulo}',
      errorBuilder: (_, _, _) => icono,
    );
  }
}
