import 'package:libreria/domain/models/escuela.dart';

/// Contrato de los convenios con escuelas.
abstract class EscuelaRepository {
  Future<List<Escuela>> getEscuelas();
}
