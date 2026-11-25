/// Calcula si el local está abierto según el horario habitual.
/// Es Dart puro para poder testearlo con cualquier fecha.
class EstadoLocal {
  const EstadoLocal({required this.abierto, required this.detalle});

  final bool abierto;
  final String detalle;

  @override
  bool operator ==(Object other) =>
      other is EstadoLocal &&
      other.abierto == abierto &&
      other.detalle == detalle;

  @override
  int get hashCode => Object.hash(abierto, detalle);
}

/// Minutos desde la medianoche.
typedef Turno = ({int desde, int hasta});

/// PENDIENTE: la fecha del cambio de temporada no es fija (aprox. octubre y
/// abril); se toma verano de octubre a marzo.
bool esVerano(DateTime fecha) => fecha.month >= 10 || fecha.month <= 3;

List<Turno> turnosDe(DateTime fecha) {
  if (fecha.weekday == DateTime.sunday) return const [];
  return [
    (desde: 9 * 60, hasta: 13 * 60),
    esVerano(fecha)
        ? (desde: 17 * 60 + 30, hasta: 21 * 60)
        : (desde: 16 * 60 + 30, hasta: 20 * 60),
  ];
}

String _hora(int minutos) =>
    '${minutos ~/ 60}:${(minutos % 60).toString().padLeft(2, '0')}';

EstadoLocal estadoDelLocal(DateTime ahora) {
  final minutos = ahora.hour * 60 + ahora.minute;
  for (final turno in turnosDe(ahora)) {
    if (minutos < turno.desde) {
      return EstadoLocal(
        abierto: false,
        detalle: 'Abre hoy a las ${_hora(turno.desde)}',
      );
    }
    if (minutos < turno.hasta) {
      return EstadoLocal(
        abierto: true,
        detalle: 'Cierra a las ${_hora(turno.hasta)}',
      );
    }
  }
  final manana = ahora.add(const Duration(days: 1));
  return EstadoLocal(
    abierto: false,
    detalle: manana.weekday == DateTime.sunday
        ? 'Abre el lunes a las 9:00'
        : 'Abre mañana a las 9:00',
  );
}
