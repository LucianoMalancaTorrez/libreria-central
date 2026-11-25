import 'package:flutter/foundation.dart';
import 'package:libreria/data/local/libros_dao.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Muestra primero la copia en SQLite y después lo que llega de la nube,
/// actualizando la copia. Si la base falla, la app sigue con la nube.
class LibroRepositoryConCopiaLocal implements LibroRepository {
  LibroRepositoryConCopiaLocal(this._remoto, this._dao);

  final LibroRepository _remoto;
  final LibrosDao _dao;

  @override
  Stream<List<Libro>> observarLibros() async* {
    try {
      final copia = await _dao.todos();
      if (copia.isNotEmpty) yield copia;
    } catch (e) {
      debugPrint('Copia local no disponible: $e');
    }
    await for (final libros in _remoto.observarLibros()) {
      yield libros;
      try {
        await _dao.reemplazarTodos(libros);
      } catch (e) {
        debugPrint('No se pudo guardar la copia local: $e');
      }
    }
  }
}
