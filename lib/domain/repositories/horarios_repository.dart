import 'package:libreria/domain/models/horario_atencion.dart';

/// Contrato de horarios e información de contacto.
abstract class HorariosRepository {
  Stream<Horarios> observarHorarios();
  Future<InfoLibreria> getInfoLibreria();
}

abstract class HorariosAdminRepository {
  Future<void> guardarHorarios(Horarios horarios);
}
