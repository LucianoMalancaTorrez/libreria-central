import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

class FilaHorario extends StatelessWidget {
  final String temporada;
  final String horario;
  const FilaHorario({
    super.key,
    required this.temporada,
    required this.horario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          temporada,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colores.leatherDeep,
          ),
        ),
        const SizedBox(height: 2),
        Text(horario, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
