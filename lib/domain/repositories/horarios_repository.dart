import 'package:libreria/domain/models/horario_atencion.dart';

/// Contrato de horarios e información de contacto.
abstract class HorariosRepository {
  Future<List<HorarioAtencion>> getHorarios();
  Future<InfoLibreria> getInfoLibreria();
}
