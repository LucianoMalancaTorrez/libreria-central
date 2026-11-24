import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

class FilaDato extends StatelessWidget {
  final IconData icono;
  final String texto;
  const FilaDato({super.key, required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, size: 20, color: AppColors.leather),
        const SizedBox(width: 10),
        Expanded(
          child: Text(texto, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
