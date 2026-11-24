// lib/repositories/escuela_repository.dart
// Interfaz para la gestión de convenios con escuelas.

import '../models/escuela.dart';

abstract class EscuelaRepository {
  Future<List<Escuela>> getEscuelas();
  Future<Escuela?> getEscuelaPorId(String id);
}

