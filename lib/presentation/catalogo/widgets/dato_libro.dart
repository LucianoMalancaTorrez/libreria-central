import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

class DatoLibro extends StatelessWidget {
  final String label;
  final String valor;
  const DatoLibro({super.key, required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colores.parchmentDeep,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colores.brass.withValues(alpha: 0.4)),
      ),
      child: Text(
        '$label: $valor',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
