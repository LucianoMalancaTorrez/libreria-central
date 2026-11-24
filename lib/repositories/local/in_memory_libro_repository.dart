// lib/repositories/local/in_memory_libro_repository.dart
// Implementación local en memoria del repositorio de libros,
// consumiendo los datos mock iniciales.

import '../../data/libros_mock.dart';
import '../../models/libro.dart';
import '../libro_repository.dart';

class InMemoryLibroRepository implements LibroRepository {
  final List<Libro> _libros;

  InMemoryLibroRepository({List<Libro>? libros})
      : _libros = List.unmodifiable(libros ?? librosMock);

  @override
  Future<List<Libro>> getLibros() async {
    return _libros;
  }

  @override
  Future<List<Libro>> buscarLibros(String query) async {
    final queryLimpia = query.trim().toLowerCase();
    if (queryLimpia.isEmpty) return _libros;

    return _libros.where((libro) {
      return libro.titulo.toLowerCase().contains(queryLimpia) ||
          libro.autor.toLowerCase().contains(queryLimpia) ||
          libro.genero.toLowerCase().contains(queryLimpia);
    }).toList();
  }

  @override
  Future<Libro?> getLibroPorId(String id) async {
    try {
      return _libros.firstWhere((libro) => libro.id == id);
    } catch (_) {
      return null;
    }
  }
}

