import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

class FotoPlaceholder extends StatelessWidget {
  final double alto;
  final IconData icono;
  final String etiqueta;

  const FotoPlaceholder({
    super.key,
    required this.alto,
    this.icono = Icons.photo_camera_back_outlined,
    this.etiqueta = 'Foto del local',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colores.leather.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colores.brass.withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 36, color: context.colores.leather),
          const SizedBox(height: 8),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colores.leatherDeep,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
