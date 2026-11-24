// lib/models/horario_atencion.dart
// Modelos de datos para horarios y contacto de la librería.

class HorarioAtencion {
  final String temporada;
  final String horario;

  const HorarioAtencion({
    required this.temporada,
    required this.horario,
  });
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

