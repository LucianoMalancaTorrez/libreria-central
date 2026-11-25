import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Lee el catálogo de ejemplo desde los assets. El JSON se convierte en un
/// Isolate (compute) para no trabar la pantalla mientras se procesa.
class AssetLibroRepository implements LibroRepository {
  List<Libro>? _cache;

  @override
  Stream<List<Libro>> observarLibros() => Stream.fromFuture(_leer());

  Future<List<Libro>> _leer() async {
    final cache = _cache;
    if (cache != null) return cache;
    final texto = await rootBundle.loadString('assets/data/libros.json');
    final libros = await compute(parsearLibros, texto);
    _cache = libros;
    return libros;
  }
}

/// Función de nivel superior: es lo que puede ejecutarse en otro Isolate.
List<Libro> parsearLibros(String texto) => [
  for (final item in jsonDecode(texto) as List<dynamic>)
    Libro.fromJson(item as Map<String, dynamic>),
];
