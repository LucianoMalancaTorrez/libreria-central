import 'package:libreria/domain/logic/club_lectura.dart';

/// El recordatorio de un encuentro sale ese mismo jueves a las 10.
/// Devuelve null si esa hora ya pasó.
DateTime? horaDelRecordatorio(DateTime encuentro, DateTime ahora) {
  final hora = DateTime(encuentro.year, encuentro.month, encuentro.day, 10);
  return hora.isAfter(ahora) ? hora : null;
}

/// Primer jueves a las 10 posterior a [ahora]. Desde ahí se repite solo.
DateTime proximoAvisoSemanal(DateTime ahora) {
  for (var dias = 0; ; dias++) {
    final dia = DateTime(ahora.year, ahora.month, ahora.day + dias, 10);
    if (esDiaDeClub(dia) && dia.isAfter(ahora)) return dia;
  }
}
