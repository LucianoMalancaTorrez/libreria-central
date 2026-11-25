import 'package:flutter/foundation.dart';
import 'package:libreria/data/local/libros_dao.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Muestra primero la copia en SQLite y después lo que llega de la nube,
/// actualizando la copia. Una nube vacía o con error nunca borra la copia.
class LibroRepositoryConCopiaLocal implements LibroRepository {
  LibroRepositoryConCopiaLocal(this._remoto, this._dao);

  final LibroRepository _remoto;
  final LibrosDao _dao;

  @override
  Stream<List<Libro>> observarLibros() async* {
    var hayCopia = false;
    try {
      final copia = await _dao.todos();
      if (copia.isNotEmpty) {
        hayCopia = true;
        yield copia;
      }
    } catch (e) {
      debugPrint('Copia local no disponible: $e');
    }
    try {
      await for (final libros in _remoto.observarLibros()) {
        // Sin conexión la nube puede responder vacío: se conserva la copia.
        if (libros.isEmpty && hayCopia) continue;
        yield libros;
        if (libros.isEmpty) continue;
        try {
          await _dao.reemplazarTodos(libros);
          hayCopia = true;
        } catch (e) {
          debugPrint('No se pudo guardar la copia local: $e');
        }
      }
    } catch (e) {
      if (!hayCopia) rethrow;
      debugPrint('Nube no disponible, queda la copia local: $e');
    }
  }
}
