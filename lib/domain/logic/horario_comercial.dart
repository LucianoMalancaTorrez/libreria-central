import 'package:libreria/domain/models/horario_atencion.dart';

/// Calcula si el local está abierto según el horario habitual.
/// Es Dart puro para poder testearlo con cualquier fecha.
class EstadoLocal {
  const EstadoLocal({required this.abierto, required this.detalle});

  final bool abierto;
  final String detalle;
}

/// PENDIENTE: la fecha del cambio de temporada no es fija (aprox. octubre y
/// abril); se toma verano de octubre a marzo.
bool esVerano(DateTime fecha) => fecha.month >= 10 || fecha.month <= 3;

HorarioTemporada _temporada(DateTime fecha, Horarios horarios) =>
    esVerano(fecha) ? horarios.verano : horarios.invierno;

EstadoLocal estadoDelLocal(DateTime ahora, Horarios horarios) {
  final minutos = ahora.hour * 60 + ahora.minute;
  if (ahora.weekday != DateTime.sunday) {
    final hoy = _temporada(ahora, horarios);
    for (final turno in [hoy.manana, hoy.tarde]) {
      if (minutos < turno.desde) {
        return EstadoLocal(
          abierto: false,
          detalle: 'Abre hoy a las ${Turno.hora(turno.desde)}',
        );
      }
      if (minutos < turno.hasta) {
        return EstadoLocal(
          abierto: true,
          detalle: 'Cierra a las ${Turno.hora(turno.hasta)}',
        );
      }
    }
  }
  var proximo = DateTime(ahora.year, ahora.month, ahora.day + 1);
  final saltaDomingo = proximo.weekday == DateTime.sunday;
  if (saltaDomingo) {
    proximo = DateTime(proximo.year, proximo.month, proximo.day + 1);
  }
  final apertura = Turno.hora(_temporada(proximo, horarios).manana.desde);
  return EstadoLocal(
    abierto: false,
    detalle: 'Abre ${saltaDomingo ? 'el lunes' : 'mañana'} a las $apertura',
  );
}
