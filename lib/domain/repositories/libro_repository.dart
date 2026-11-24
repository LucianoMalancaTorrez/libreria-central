import 'package:libreria/domain/models/libro.dart';

/// Contrato del catálogo, independiente de dónde estén guardados los datos.
abstract class LibroRepository {
  Future<List<Libro>> getLibros();
}
