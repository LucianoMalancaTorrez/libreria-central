// lib/screens/historia_screen.dart
// Historia real de la librería, según los recuerdos de Amelia Winterbach:
// - Otto Winterbach (abuelo): abrió en 1952 con pocos libros y el mostrador de madera.
// - Ernesto Winterbach (padre): armó la sección de libros infantiles.
// - Amelia Winterbach: a cargo desde 1998 cuidando el espíritu del barrio.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_center.dart';

class HistoriaScreen extends StatelessWidget {
  const HistoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Nuestra historia')),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _FotoPlaceholder(
              alto: 200,
              icono: Icons.storefront,
              etiqueta: 'Mostrador de madera original (1952)',
            ),
            const SizedBox(height: 20),
            Text(
              'Librería Central Winterbach',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.leatherDeep,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Conocida en el barrio como «lo de Amelia»',
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.bottleGreenDark,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'En 1952, nuestro abuelo Otto llegó desde Alemania después de la guerra '
              'con el sueño de construir un rincón de encuentro para la ciudad. Abrió la '
              'librería con muy poquitos ejemplares y un mostrador de madera que con orgullo '
              'todavía nos acompaña en el local.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 14),
            Text(
              'Con los años tomó la posta mi papá, Ernesto, quien con su calidez armó '
              'la querida sección de libros infantiles, contagiando el placer de la lectura '
              'a generaciones de chicos de la zona.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 14),
            Text(
              'En 1998 me tocó hacerme cargo a mí, Amelia, cuando papá enfermó. '
              'Desde entonces seguimos defendiendo esa misma tradición: puertas abiertas, '
              'tiempo para charlar, un café o un tecito, y la recomendación sincera de a un libro a la vez.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Rincones de nuestra librería',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _FotoPlaceholder(
                    alto: 130,
                    icono: Icons.person_outline,
                    etiqueta: 'Foto histórica: Don Otto',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _FotoPlaceholder(
                    alto: 130,
                    icono: Icons.menu_book,
                    etiqueta: 'Rincón de literatura infantil',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Belgrano 742 (al lado de la farmacia) · Mendoza',
                style: AppTheme.stampLabel(color: AppColors.leather),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FotoPlaceholder extends StatelessWidget {
  final double alto;
  final IconData icono;
  final String etiqueta;

  const _FotoPlaceholder({
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
        color: AppColors.leather.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brass.withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icono,
            size: 36,
            color: AppColors.leather,
          ),
          const SizedBox(height: 8),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.leatherDeep,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
