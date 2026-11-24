import 'package:flutter/widgets.dart';
import 'package:libreria/data/repositories/in_memory_escuela_repository.dart';
import 'package:libreria/data/repositories/in_memory_horarios_repository.dart';
import 'package:libreria/data/repositories/in_memory_libro_repository.dart';
import 'package:libreria/domain/repositories/escuela_repository.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Único lugar donde se elige de dónde vienen los datos. Las pantallas solo
/// ven las interfaces, y los tests pueden pasar repositorios falsos.
class Dependencias extends InheritedWidget {
  Dependencias({
    super.key,
    required super.child,
    LibroRepository? libros,
    EscuelaRepository? escuelas,
    HorariosRepository? horarios,
  }) : libros = libros ?? InMemoryLibroRepository(),
       escuelas = escuelas ?? InMemoryEscuelaRepository(),
       horarios = horarios ?? InMemoryHorariosRepository();

  final LibroRepository libros;
  final EscuelaRepository escuelas;
  final HorariosRepository horarios;

  static Dependencias of(BuildContext context) {
    final dependencias = context.getInheritedWidgetOfExactType<Dependencias>();
    assert(dependencias != null, 'Falta Dependencias sobre este widget');
    return dependencias!;
  }

  @override
  bool updateShouldNotify(Dependencias oldWidget) => false;
}
