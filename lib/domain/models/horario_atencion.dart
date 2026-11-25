/// Un turno en minutos desde la medianoche.
class Turno {
  const Turno(this.desde, this.hasta);

  final int desde;
  final int hasta;

  bool get esValido => desde >= 0 && hasta <= 24 * 60 && desde < hasta;

  static String hora(int minutos) =>
      '${minutos ~/ 60}:${(minutos % 60).toString().padLeft(2, '0')}';
}

class HorarioTemporada {
  const HorarioTemporada({required this.manana, required this.tarde});

  factory HorarioTemporada.fromList(List<dynamic> v) => HorarioTemporada(
    manana: Turno(v[0] as int, v[1] as int),
    tarde: Turno(v[2] as int, v[3] as int),
  );

  final Turno manana;
  final Turno tarde;

  List<int> toList() => [manana.desde, manana.hasta, tarde.desde, tarde.hasta];

  String get texto =>
      'Lunes a sábado de ${Turno.hora(manana.desde)} a '
      '${Turno.hora(manana.hasta)} y de ${Turno.hora(tarde.desde)} a '
      '${Turno.hora(tarde.hasta)}';
}

class Horarios {
  const Horarios({required this.invierno, required this.verano});

  /// Horarios confirmados por Amelia.
  /// PENDIENTE: la mañana de verano se supuso igual a la de invierno.
  static const habituales = Horarios(
    invierno: HorarioTemporada(
      manana: Turno(9 * 60, 13 * 60),
      tarde: Turno(16 * 60 + 30, 20 * 60),
    ),
    verano: HorarioTemporada(
      manana: Turno(9 * 60, 13 * 60),
      tarde: Turno(17 * 60 + 30, 21 * 60),
    ),
  );

  final HorarioTemporada invierno;
  final HorarioTemporada verano;
}

class InfoLibreria {
  final String direccion;
  final String telefonoWhatsApp;
  final String usuarioInstagram;

  const InfoLibreria({
    required this.direccion,
    required this.telefonoWhatsApp,
    required this.usuarioInstagram,
  });
}
