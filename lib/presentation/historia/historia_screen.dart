/// Historia real de la librería, según los recuerdos de Amelia Winterbach:
/// Otto abrió en 1952, Ernesto armó la sección infantil y Amelia está a cargo
/// desde 1998.
library;

import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/historia/widgets/encabezado_historia.dart';
import 'package:libreria/presentation/historia/widgets/etapa_historia.dart';
import 'package:libreria/presentation/historia/widgets/foto_placeholder.dart';

class HistoriaScreen extends StatelessWidget {
  const HistoriaScreen({super.key});

  static const _etapas = <(String, String, String)>[
    (
      '1952',
      'Otto',
      'Nuestro abuelo Otto llegó desde Alemania después de la guerra con el '
          'sueño de construir un rincón de encuentro. Abrió la librería con muy '
          'poquitos ejemplares y un mostrador de madera que todavía nos '
          'acompaña.',
    ),
    (
      'Con los años',
      'Ernesto',
      'Tomó la posta mi papá, Ernesto, quien con su calidez armó la querida '
          'sección de libros infantiles para los chicos de la zona.',
    ),
    (
      '1998',
      'Amelia',
      'Me tocó hacerme cargo cuando papá enfermó. Seguimos con las puertas '
          'abiertas, tiempo para charlar, un café o un tecito y la '
          'recomendación sincera de a un libro a la vez.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveCenter(
        // Slivers: el encabezado se achica a medida que se baja.
        child: CustomScrollView(
          slivers: [
            const EncabezadoHistoria(),
            SliverList.builder(
              itemCount: _etapas.length,
              itemBuilder: (context, i) {
                final (anio, nombre, texto) = _etapas[i];
                return EtapaHistoria(anio: anio, nombre: nombre, texto: texto);
              },
            ),
            const SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                // PENDIENTE: reemplazar por las fotos reales del local.
                child: Row(
                  children: [
                    Expanded(
                      child: FotoPlaceholder(
                        alto: 140,
                        icono: Icons.person_outline,
                        etiqueta: 'Foto histórica: Don Otto',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: FotoPlaceholder(
                        alto: 140,
                        icono: Icons.menu_book,
                        etiqueta: 'Rincón de literatura infantil',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Belgrano 742 (al lado de la farmacia) · Mendoza',
                  textAlign: TextAlign.center,
                  style: AppTheme.stampLabel(color: AppColors.leather),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
