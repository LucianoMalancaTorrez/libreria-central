import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/domain/models/escuela.dart';
import 'package:libreria/domain/repositories/escuela_repository.dart';

/// Escuelas confirmadas por Amelia. Los códigos son de referencia: el control
/// real es el carnet del colegio.
class InMemoryEscuelaRepository implements EscuelaRepository {
  static const List<Escuela> _escuelas = [
    Escuela(
      id: 'esc-sarmiento',
      nombre: 'Escuela Sarmiento',
      localidad: 'Escuela del barrio, Mendoza',
      descuentoPorcentaje: LibreriaConfig.descuentoEscolar,
      codigo: 'SARMIENTO-10',
    ),
    Escuela(
      id: 'esc-san-jose',
      nombre: 'Colegio San José',
      localidad: 'Mendoza',
      descuentoPorcentaje: LibreriaConfig.descuentoEscolar,
      codigo: 'SANJOSE-10',
    ),
  ];

  @override
  Future<List<Escuela>> getEscuelas() async => _escuelas;
}
