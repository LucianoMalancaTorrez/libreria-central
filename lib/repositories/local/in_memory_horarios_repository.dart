// lib/repositories/local/in_memory_horarios_repository.dart
// Implementación local en memoria para horarios e información de contacto,
// actualizada con los datos reales provistos por Amelia Winterbach:
// - Dirección: Belgrano 742 (al lado de la farmacia).
// - Instagram: libreriacentral_ (gestionado por Valentina).
// - Horarios invierno: Lunes a sábado 9:00 a 13:00 y 16:30 a 20:00 (aprox. abril a octubre).
// - Horarios verano: Lunes a sábado 9:00 a 13:00 y 17:30 a 21:00 (aprox. octubre a abril).

import '../../models/horario_atencion.dart';
import '../horarios_repository.dart';

class InMemoryHorariosRepository implements HorariosRepository {
  static const List<HorarioAtencion> _horariosPorDefecto = [
    HorarioAtencion(
      temporada: 'Invierno (abril a octubre)',
      horario: 'Lunes a sábado de 9:00 a 13:00 y de 16:30 a 20:00',
    ),
    HorarioAtencion(
      temporada: 'Verano (octubre a abril)',
      horario: 'Lunes a sábado de 9:00 a 13:00 y de 17:30 a 21:00',
    ),
  ];

  static const InfoLibreria _infoPorDefecto = InfoLibreria(
    direccion: 'Belgrano 742 (al lado de la farmacia), Mendoza',
    telefonoWhatsApp: '5492610000000', // Amelia lo entregará en persona
    usuarioInstagram: 'libreriacentral_',
  );

  final List<HorarioAtencion> _horarios;
  final InfoLibreria _info;

  InMemoryHorariosRepository({
    List<HorarioAtencion>? horarios,
    InfoLibreria? info,
  })  : _horarios = horarios ?? _horariosPorDefecto,
        _info = info ?? _infoPorDefecto;

  @override
  Future<List<HorarioAtencion>> getHorarios() async {
    return List.unmodifiable(_horarios);
  }

  @override
  Future<InfoLibreria> getInfoLibreria() async {
    return _info;
  }
}
