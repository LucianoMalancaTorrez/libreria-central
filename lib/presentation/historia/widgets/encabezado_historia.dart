import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

/// Barra que se contrae, con elementos superpuestos mediante un Stack.
class EncabezadoHistoria extends StatelessWidget {
  const EncabezadoHistoria({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: context.colores.leatherDeep,
      foregroundColor: context.colores.parchment,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Nuestra historia',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: context.colores.parchment),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: context.colores.leatherDeep),
            Icon(Icons.storefront, size: 120, color: context.colores.brass),
            Positioned(
              right: 16,
              bottom: 56,
              child: Text(
                'Desde 1952',
                style: AppTheme.stampLabel(color: context.colores.parchment),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
