// lib/screens/credencial_escuela_screen.dart
// Credencial visual para canjear el descuento de la escuela en el local.
// Adaptada según las observaciones de Amelia:
// - Tipografía grande y de alto contraste para facilitar la lectura de Amelia en caja.
// - Código alfanumérico simple (sin necesidad de escanear códigos QR complejos).
// - Requiere presentar el carnet escolar del alumno o docente.
// - Aclara el alcance acordado: 10% en literatura, cuentos y novelas (excluye manuales de texto).
// - Validez durante el ciclo lectivo (marzo a diciembre).

import 'package:flutter/material.dart';
import '../models/escuela.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_center.dart';

class CredencialEscuelaScreen extends StatelessWidget {
  final Escuela escuela;

  const CredencialEscuelaScreen({
    super.key,
    required this.escuela,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mostrá esto en caja'),
      ),
      body: ResponsiveCenter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _TarjetaCredencial(escuela: escuela),
              const SizedBox(height: 24),
              _InstruccionesCanje(escuela: escuela),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver a la lista de escuelas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaCredencial extends StatelessWidget {
  final Escuela escuela;

  const _TarjetaCredencial({required this.escuela});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.parchmentDeep,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brass, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.leather.withValues(alpha: 0.12),
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
            decoration: const BoxDecoration(
              color: AppColors.leatherDeep,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.brass,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIBRERÍA CENTRAL WINTERBACH',
                        style: AppTheme.stampLabel(color: AppColors.parchment)
                            .copyWith(letterSpacing: 2, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '«lo de Amelia» · Convenio Educativo',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.parchment.withValues(alpha: 0.9),
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
                    color: AppColors.leatherDeep,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.leather,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      escuela.localidad,
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                // Cartel del beneficio / porcentaje en tamaño grande
                Text(
                  'BENEFICIO EN EL LOCAL',
                  style: AppTheme.stampLabel(color: AppColors.leather)
                      .copyWith(letterSpacing: 1.5, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.bottleGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.bottleGreen,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${escuela.descuentoPorcentaje}% DE DESCUENTO',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.bottleGreenDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'En literatura, novelas y cuentos',
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.leatherDeep,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '(No incluye manuales ni libros de texto escolares)',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.leather.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Recuadro del código en tipografía muy grande y clara
                Text(
                  'CÓDIGO PARA MOSTRAR EN CAJA',
                  style: AppTheme.stampLabel(color: AppColors.leather)
                      .copyWith(letterSpacing: 1.2, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.parchment,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.brass,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    escuela.codigo,
                    textAlign: TextAlign.center,
                    style: AppTheme.stampLabel(color: AppColors.leatherDeep).copyWith(
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
                    color: AppColors.brass.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.badge_outlined, color: AppColors.leatherDeep),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Presentar junto con el carnet de alumno o docente en el mostrador.',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.leatherDeep,
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
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: AppColors.leather,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Vigente durante el ciclo lectivo: marzo a diciembre',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.leather.withValues(alpha: 0.9),
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

class _InstruccionesCanje extends StatelessWidget {
  final Escuela escuela;

  const _InstruccionesCanje({required this.escuela});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  color: AppColors.bottleGreen,
                ),
                const SizedBox(width: 10),
                Text(
                  '¿Cómo usar este descuento con Amelia?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '1. Acercate al mostrador de Librería Central (Belgrano 742).\n'
              '2. Mostrale a Amelia esta pantalla y tu carnet del colegio antes de abonar.\n'
              '3. El descuento del 10% se aplica en el acto sobre libros de literatura, novelas y cuentos.\n\n'
              '• Beneficio presencial válido para alumnos, familias y docentes de la institución durante las clases (marzo a diciembre).\n'
              '• Los manuales escolares de texto no tienen descuento por contar con precio fijado por editorial.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
