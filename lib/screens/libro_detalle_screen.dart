// lib/screens/libro_detalle_screen.dart
// Cumple el requisito: "consultar información del libro".
//
// NOTA (pedido de la clienta): sin precio ni estado de stock — la app
// es de consulta, no de venta online.

import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_center.dart';

class LibroDetalleScreen extends StatelessWidget {
  final Libro libro;
  const LibroDetalleScreen({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(libro.titulo)),
      body: ResponsiveCenter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 160,
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.leather.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.brass.withValues(alpha: 0.6),
                    ),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 64,
                    color: AppColors.leather,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(libro.titulo, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                libro.autor,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Dato(label: 'Editorial', valor: libro.editorial),
                  _Dato(label: 'Género', valor: libro.genero),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              Text('Descripción', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                libro.descripcion,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String label;
  final String valor;
  const _Dato({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.parchmentDeep,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.brass.withValues(alpha: 0.4)),
      ),
      child: Text('$label: $valor', style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
