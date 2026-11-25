/// El club de lectura se reúne los jueves.
/// PENDIENTE: Amelia todavía no indicó el horario.
const diaClubLectura = DateTime.thursday;

bool esDiaDeClub(DateTime fecha) => fecha.weekday == diaClubLectura;

/// Los próximos [cantidad] jueves, contando hoy.
List<DateTime> proximosEncuentros(DateTime desde, {int cantidad = 4}) {
  final hoy = DateTime(desde.year, desde.month, desde.day);
  final faltan = (diaClubLectura - hoy.weekday) % 7;
  return [
    for (var i = 0; i < cantidad; i++)
      DateTime(hoy.year, hoy.month, hoy.day + faltan + 7 * i),
  ];
}

String fechaLarga(DateTime fecha) {
  const dias = [
    'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo', //
  ];
  const meses = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', //
    'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];
  return '${dias[fecha.weekday - 1]} ${fecha.day} de ${meses[fecha.month - 1]}';
}
