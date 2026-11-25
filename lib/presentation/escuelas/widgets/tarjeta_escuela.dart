import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/models/escuela.dart';

class TarjetaEscuela extends StatelessWidget {
  final Escuela escuela;
  final VoidCallback onTap;

  const TarjetaEscuela({super.key, required this.escuela, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.bottleGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: AppColors.bottleGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          escuela.nombre,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.leather,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                escuela.localidad,
                                style: textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beneficio: ${escuela.descuentoPorcentaje}% de descuento',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.bottleGreenDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'En literatura, novelas y cuentos',
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                      color: AppColors.leather.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.badge_outlined, size: 16),
                label: const Text('Mostrá esto en caja'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
