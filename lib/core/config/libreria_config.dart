/// Datos del negocio que pueden cambiar. Se editan solo acá.
class LibreriaConfig {
  const LibreriaConfig._();

  static const nombre = 'Librería Central Winterbach';
  static const apodo = '«lo de Amelia»';
  static const direccion = 'Belgrano 742 (al lado de la farmacia), Mendoza';

  // PENDIENTE: número de ejemplo; Amelia entrega el real en persona.
  static const telefonoWhatsApp = '5492610000000';

  // PENDIENTE: confirmar el usuario exacto con Valentina.
  static const usuarioInstagram = 'libreriacentral_';

  static const descuentoEscolar = 10;
  static const vigenciaConvenio = 'marzo a diciembre';

  static Uri enlaceWhatsApp(String mensaje) =>
      Uri.https('wa.me', '/$telefonoWhatsApp', {'text': mensaje});

  static Uri enlaceMapa(String direccion) => Uri.https(
    'www.google.com',
    '/maps/search/',
    {'api': '1', 'query': direccion},
  );

  static Uri enlaceInstagram(String usuario) =>
      Uri.https('instagram.com', '/$usuario');
}
