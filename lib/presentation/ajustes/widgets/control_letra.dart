import 'package:flutter/material.dart';
import 'package:libreria/presentation/ajustes/viewmodels/ajustes_view_model.dart';

/// Tamaño de letra de toda la app.
class ControlLetra extends StatelessWidget {
  const ControlLetra({super.key, required this.ajustes});

  final AjustesViewModel ajustes;

  static const _nombres = ['Normal', 'Grande', 'Muy grande'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ajustes,
      builder: (context, _) {
        final nombre = _nombres[ajustes.tamanoLetra];
        return ListTile(
          leading: const Icon(Icons.format_size),
          title: Text('Tamaño de letra: $nombre'),
          subtitle: Slider(
            value: ajustes.tamanoLetra.toDouble(),
            max: 2,
            divisions: 2,
            label: nombre,
            onChanged: (v) => ajustes.cambiarTamanoLetra(v.round()),
          ),
        );
      },
    );
  }
}
