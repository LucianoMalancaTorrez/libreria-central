import 'package:flutter/material.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/models/escuela.dart';

class TarjetaCredencial extends StatelessWidget {
  final Escuela escuela;

  const TarjetaCredencial({super.key, required this.escuela});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colores.parchmentDeep,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colores.brass, width: 2),
        boxShadow: [
          BoxShadow(
            color: context.colores.leather.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabecera estilo sello / membrete de librería
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: context.colores.leatherDeep,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: context.colores.brass,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIBRERÍA CENTRAL WINTERBACH',
                        style:
                            AppTheme.stampLabel(
                              color: context.colores.parchment,
                            ).copyWith(
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '«lo de Amelia» · Convenio Educativo',
                        style: textTheme.labelSmall?.copyWith(
                          color: context.colores.parchment.withValues(
                            alpha: 0.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const SizedBox(height: 6),
                Text(
                  escuela.nombre,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colores.leatherDeep,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: context.colores.leather,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        escuela.localidad,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                // Cartel del beneficio / porcentaje en tamaño grande
                Text(
                  'BENEFICIO EN EL LOCAL',
                  style: AppTheme.stampLabel(color: context.colores.leather)
                      .copyWith(letterSpacing: 1.5, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: context.colores.bottleGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: context.colores.bottleGreen,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${escuela.descuentoPorcentaje}% DE DESCUENTO',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          color: context.colores.bottleGreenDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'En literatura, novelas y cuentos',
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall?.copyWith(
                          color: context.colores.leatherDeep,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '(No incluye manuales ni libros de texto escolares)',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: context.colores.leather.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Recuadro del código en tipografía muy grande y clara
                Text(
                  'CÓDIGO PARA MOSTRAR EN CAJA',
                  style: AppTheme.stampLabel(color: context.colores.leather)
                      .copyWith(letterSpacing: 1.2, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: context.colores.parchment,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colores.brass, width: 2),
                  ),
                  child: Text(
                    escuela.codigo,
                    textAlign: TextAlign.center,
                    style:
                        AppTheme.stampLabel(color: context.colores.leatherDeep)
                            .copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                  ),
                ),
                const SizedBox(height: 18),

                // Requisito del carnet (pedido por Amelia)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colores.brass.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.badge_outlined,
                        color: context.colores.leatherDeep,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Presentar junto con el carnet de alumno o docente en el mostrador.',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colores.leatherDeep,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: context.colores.leather,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Vigente durante el ciclo lectivo: ${LibreriaConfig.vigenciaConvenio}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: context.colores.leather.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
