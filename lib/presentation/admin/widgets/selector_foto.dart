import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libreria/core/plataforma/politicas.dart';

/// Saca o elige la foto de la tapa. Se achica antes de guardarla.
class SelectorFoto extends StatelessWidget {
  const SelectorFoto({super.key, required this.foto, required this.alCambiar});

  final String foto;
  final ValueChanged<Uint8List> alCambiar;

  Future<void> _elegir(BuildContext context, ImageSource origen) async {
    final mensajero = ScaffoldMessenger.of(context);
    try {
      final archivo = await ImagePicker().pickImage(
        source: origen,
        maxWidth: 500,
        maxHeight: 700,
        imageQuality: 60,
      );
      if (archivo == null) return;
      final bytes = await archivo.readAsBytes();
      // Mismo límite que las reglas de la base de datos.
      if (bytes.length > 500000) {
        mensajero.showSnackBar(
          const SnackBar(content: Text('La imagen es demasiado grande.')),
        );
        return;
      }
      alCambiar(bytes);
    } catch (e) {
      debugPrint('Foto: $e');
      mensajero.showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la cámara o galería.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (foto.isNotEmpty)
          Image.memory(
            base64Decode(foto),
            height: 180,
            semanticLabel: 'Foto de la tapa',
          ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            if (const Politicas().ofrecerSacarFoto)
              OutlinedButton.icon(
                onPressed: () => _elegir(context, ImageSource.camera),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Sacar foto'),
              ),
            OutlinedButton.icon(
              onPressed: () => _elegir(context, ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Galería'),
            ),
          ],
        ),
      ],
    );
  }
}
