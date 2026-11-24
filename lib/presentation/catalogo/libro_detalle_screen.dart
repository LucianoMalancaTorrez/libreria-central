/// Cumple el requisito: "consultar información del libro".
///
/// NOTA (pedido de la clienta): sin precio ni estado de stock — la app
/// es de consulta, no de venta online.
library;

import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/catalogo/widgets/dato_libro.dart';

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
              Text(
                libro.titulo,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(libro.autor, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  DatoLibro(label: 'Editorial', valor: libro.editorial),
                  DatoLibro(label: 'Género', valor: libro.genero),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Descripción',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
