import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';

/// Horarios y contacto incluidos en la app.
class InMemoryHorariosRepository implements HorariosRepository {
  @override
  Stream<Horarios> observarHorarios() => Stream.value(Horarios.habituales);

  @override
  Future<InfoLibreria> getInfoLibreria() async => const InfoLibreria(
    direccion: LibreriaConfig.direccion,
    telefonoWhatsApp: LibreriaConfig.telefonoWhatsApp,
    usuarioInstagram: LibreriaConfig.usuarioInstagram,
  );
}
