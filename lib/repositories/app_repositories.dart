// lib/repositories/app_repositories.dart
// Contenedor central de repositorios de la aplicación.
// Permite que las pantallas accedan a los datos a través de interfaces abstractas.
// Para migrar a Firestore más adelante, solo se reemplazan estas instancias
// sin modificar el código de ninguna pantalla ni de los modelos.

import 'escuela_repository.dart';
import 'horarios_repository.dart';
import 'libro_repository.dart';
import 'local/in_memory_escuela_repository.dart';
import 'local/in_memory_horarios_repository.dart';
import 'local/in_memory_libro_repository.dart';

class AppRepositories {
  AppRepositories._();

  static LibroRepository libroRepository = InMemoryLibroRepository();
  static EscuelaRepository escuelaRepository = InMemoryEscuelaRepository();
  static HorariosRepository horariosRepository = InMemoryHorariosRepository();

  /// Permite restablecer o configurar implementaciones personalizadas
  /// (por ejemplo para pruebas unitarias o al conectar Firebase Firestore).
  static void configurar({
    LibroRepository? nuevoLibroRepository,
    EscuelaRepository? nuevoEscuelaRepository,
    HorariosRepository? nuevoHorariosRepository,
  }) {
    if (nuevoLibroRepository != null) {
      libroRepository = nuevoLibroRepository;
    }
    if (nuevoEscuelaRepository != null) {
      escuelaRepository = nuevoEscuelaRepository;
    }
    if (nuevoHorariosRepository != null) {
      horariosRepository = nuevoHorariosRepository;
    }
  }
}

