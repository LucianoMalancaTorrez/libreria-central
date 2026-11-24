// lib/repositories/horarios_repository.dart
// Interfaz para la obtención de horarios de atención e información de contacto.

import '../models/horario_atencion.dart';

abstract class HorariosRepository {
  Future<List<HorarioAtencion>> getHorarios();
  Future<InfoLibreria> getInfoLibreria();
}

