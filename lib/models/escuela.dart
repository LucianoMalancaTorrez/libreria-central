class Escuela {
  final String id;
  final String nombre;
  final String localidad;
  final int descuentoPorcentaje;
  final DateTime vigenteHasta;
  final String codigo;
  final String alcance;
  final bool requiereCarnet;

  const Escuela({
    required this.id,
    required this.nombre,
    required this.localidad,
    required this.descuentoPorcentaje,
    required this.vigenteHasta,
    required this.codigo,
    this.alcance = 'En literatura, cuentos y novelas (no aplica a manuales de texto escolares)',
    this.requiereCarnet = true,
  });

  String get fechaVigenciaFormateada {
    final dia = vigenteHasta.day.toString().padLeft(2, '0');
    final mes = vigenteHasta.month.toString().padLeft(2, '0');
    final anio = vigenteHasta.year.toString();
    return '$dia/$mes/$anio';
  }
}
