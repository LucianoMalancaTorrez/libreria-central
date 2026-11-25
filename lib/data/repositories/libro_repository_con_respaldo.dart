import 'package:flutter/foundation.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Si no hay ningún libro real para mostrar, usa el catálogo de ejemplo.
/// Va por fuera de la copia local, así el ejemplo nunca se guarda en ella.
class LibroRepositoryConRespaldo implements LibroRepository {
  LibroRepositoryConRespaldo(this._principal, this._respaldo);

  final LibroRepository _principal;
  final LibroRepository _respaldo;

  @override
  Stream<List<Libro>> observarLibros() async* {
    var mostroReales = false;
    try {
      await for (final libros in _principal.observarLibros()) {
        if (libros.isEmpty) {
          yield await _respaldo.observarLibros().first;
        } else {
          mostroReales = true;
          yield libros;
        }
      }
    } catch (e) {
      debugPrint('Catálogo no disponible: $e');
      if (!mostroReales) yield await _respaldo.observarLibros().first;
    }
  }
}
