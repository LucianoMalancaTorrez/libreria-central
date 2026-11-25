/// Política de privacidad: qué se guarda, qué sale del dispositivo y qué
/// permisos pide la app.
library;

import 'package:flutter/material.dart';
import 'package:libreria/core/widgets/responsive_center.dart';

class PrivacidadScreen extends StatelessWidget {
  const PrivacidadScreen({super.key});

  static const _apartados = <(String, String)>[
    (
      'Sin cuentas de clientes ni compras',
      'No pedimos registro, no vendemos por la app y no cobramos nada.',
    ),
    (
      'Qué se guarda en tu dispositivo',
      'Tu lista de libros, el tamaño de letra y si querés avisos. '
          'Podés borrar la lista cuando quieras.',
    ),
    (
      'Qué sale del dispositivo',
      'Al abrir un libro, el título y el autor se consultan en Open Library '
          'para traer la tapa. Las tipografías se descargan de Google Fonts. '
          'WhatsApp, el mapa e Instagram se abren solo si vos los tocás.',
    ),
    (
      'Datos en la nube',
      'El catálogo y los horarios se guardan en Google Firebase. La única '
          'cuenta es la de la librería, para actualizarlos.',
    ),
    (
      'Avisos desde la librería',
      'En Android, si activás los avisos, Google Firebase guarda un código '
          'del dispositivo para poder enviarte las novedades del club.',
    ),
    (
      'Permisos',
      'Internet: para tapas y tipografías.\n'
          'Cámara y fotos: solo en Administración, cuando se elige la tapa '
          'de un libro.\n'
          'Notificaciones: solo si activás los avisos del club de lectura. '
          'Podés desactivarlos en Club de lectura > Avisos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Privacidad y permisos')),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final (titulo, texto) in _apartados) ...[
              Text(titulo, style: textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(texto, style: textTheme.bodyLarge),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
