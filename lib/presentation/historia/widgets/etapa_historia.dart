import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

/// Una generación de la familia; aparece con una animación suave.
class EtapaHistoria extends StatelessWidget {
  const EtapaHistoria({
    super.key,
    required this.anio,
    required this.nombre,
    required this.texto,
  });

  final String anio;
  final String nombre;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, valor, child) => Opacity(
        opacity: valor,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - valor)),
          child: child,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                anio,
                style: AppTheme.stampLabel(color: AppColors.bottleGreenDark),
              ),
              Text(nombre, style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(texto, style: textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
