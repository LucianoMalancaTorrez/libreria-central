// lib/repositories/libro_repository.dart
// Interfaz para la obtención y búsqueda de libros del catálogo.
// Permite desacoplar las vistas de la fuente de datos (memoria local,
// Firestore, etc.).

import '../models/libro.dart';

abstract class LibroRepository {
  Future<List<Libro>> getLibros();
  Future<List<Libro>> buscarLibros(String query);
  Future<Libro?> getLibroPorId(String id);
}

