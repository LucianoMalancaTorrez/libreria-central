import 'package:flutter/foundation.dart';
import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Lógica de la pestaña Libros del panel.
class LibrosAdminViewModel extends ViewModel {
  LibrosAdminViewModel(this._catalogo, this._ejemplo);

  final CatalogoAdminRepository _catalogo;
  final LibroRepository _ejemplo;
  List<Libro> _libros = const [];
  bool _importando = false;

  List<Libro> get libros => _libros;
  bool get importando => _importando;

  Future<void> cargar() => escuchar<List<Libro>>(
    _catalogo.observarPublicados(),
    (libros) => _libros = libros,
    mensajeError: 'No se pudieron cargar los libros.',
  );

  /// Devuelve un mensaje solo si no se pudo borrar.
  Future<String?> eliminar(Libro libro) async {
    try {
      await _catalogo.eliminar(libro.id);
      return null;
    } catch (e) {
      debugPrint('Borrar: $e');
      return 'No se pudo borrar.';
    }
  }

  /// Sube el catálogo de ejemplo y devuelve el resultado en palabras.
  Future<String> importar() async {
    _importando = true;
    notifyListeners();
    try {
      await _catalogo.importar(await _ejemplo.observarLibros().first);
      return 'Catálogo de ejemplo cargado en la nube.';
    } catch (e) {
      debugPrint('Importar: $e');
      return 'No se pudo cargar el catálogo.';
    } finally {
      _importando = false;
      notifyListeners();
    }
  }
}
