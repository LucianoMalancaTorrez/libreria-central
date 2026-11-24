import 'package:libreria/data/local/libros_mock.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Catálogo en memoria con libros de ejemplo.
class InMemoryLibroRepository implements LibroRepository {
  InMemoryLibroRepository({List<Libro>? libros})
    : _libros = List.unmodifiable(libros ?? librosMock);

  final List<Libro> _libros;

  @override
  Future<List<Libro>> getLibros() async => _libros;
}
