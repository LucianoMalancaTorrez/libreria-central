import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre un enlace en la app externa y avisa con un SnackBar si no se pudo.
Future<void> abrirEnlace(BuildContext context, Uri uri) async {
  // Se toma antes del await para no usar el context después.
  final mensajero = ScaffoldMessenger.of(context);
  var abierto = false;
  try {
    abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('No se pudo abrir $uri: $e');
  }
  if (!abierto) {
    mensajero.showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace.')),
    );
  }
}
