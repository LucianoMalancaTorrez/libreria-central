import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

/// Destino de arrastre: al soltar una tapa, el libro pasa primero en la lista.
class ZonaDestacar extends StatelessWidget {
  const ZonaDestacar({super.key, required this.alSoltar});

  final ValueChanged<String> alSoltar;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (detalle) => alSoltar(detalle.data),
      builder: (context, candidatos, _) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: candidatos.isEmpty
              ? context.colores.parchmentDeep
              : context.colores.brass.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colores.brass),
        ),
        child: const Text(
          'Arrastrá una tapa hasta acá para ponerla primera.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
