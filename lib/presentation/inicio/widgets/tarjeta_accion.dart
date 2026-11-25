import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

class TarjetaAccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const TarjetaAccion({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icono, color: context.colores.bottleGreen, size: 32),
        title: Text(titulo, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitulo),
        trailing: Icon(Icons.chevron_right, color: context.colores.leather),
        onTap: onTap,
      ),
    );
  }
}
