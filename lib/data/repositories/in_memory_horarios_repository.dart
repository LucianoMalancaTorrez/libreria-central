import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';

/// Horarios confirmados por Amelia.
/// PENDIENTE: la mañana de verano se supuso igual a la de invierno.
class InMemoryHorariosRepository implements HorariosRepository {
  static const List<HorarioAtencion> _horarios = [
    HorarioAtencion(
      temporada: 'Invierno (abril a octubre)',
      horario: 'Lunes a sábado de 9:00 a 13:00 y de 16:30 a 20:00',
    ),
    HorarioAtencion(
      temporada: 'Verano (octubre a abril)',
      horario: 'Lunes a sábado de 9:00 a 13:00 y de 17:30 a 21:00',
    ),
  ];

  @override
  Future<List<HorarioAtencion>> getHorarios() async => _horarios;

  @override
  Future<InfoLibreria> getInfoLibreria() async => const InfoLibreria(
    direccion: LibreriaConfig.direccion,
    telefonoWhatsApp: LibreriaConfig.telefonoWhatsApp,
    usuarioInstagram: LibreriaConfig.usuarioInstagram,
  );
}
