/// El recordatorio de un encuentro sale ese mismo jueves a las 10.
/// Devuelve null si esa hora ya pasó.
DateTime? horaDelRecordatorio(DateTime encuentro, DateTime ahora) {
  final hora = DateTime(encuentro.year, encuentro.month, encuentro.day, 10);
  return hora.isAfter(ahora) ? hora : null;
}
