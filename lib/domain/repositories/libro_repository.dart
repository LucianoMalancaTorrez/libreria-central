import 'package:libreria/domain/models/libro.dart';

/// Contrato del catálogo, independiente de dónde estén guardados los datos.
abstract class LibroRepository {
  /// Emite la lista completa cada vez que cambia.
  Stream<List<Libro>> observarLibros();
}

/// Escritura del catálogo: solo la usa el panel de administración.
abstract class CatalogoAdminRepository {
  /// Solo lo que está en la nube, sin el catálogo de ejemplo.
  Stream<List<Libro>> observarPublicados();

  /// Si [libro] no tiene id, se crea uno nuevo.
  Future<void> guardar(Libro libro);
  Future<void> eliminar(String id);
  Future<void> importar(List<Libro> libros);
}
