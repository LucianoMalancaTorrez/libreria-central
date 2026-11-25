import 'package:libreria/core/config/libreria_config.dart';
import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/models/escuela.dart';

class InstruccionesCanje extends StatelessWidget {
  final Escuela escuela;

  const InstruccionesCanje({super.key, required this.escuela});

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
                Expanded(
                  child: Text(
                    '¿Cómo usar este descuento con Amelia?',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '1. Acercate al mostrador de Librería Central (Belgrano 742).\n'
              '2. Mostrale a Amelia esta pantalla y tu carnet del colegio antes de abonar.\n'
              '3. El descuento del ${LibreriaConfig.descuentoEscolar}% se aplica en el acto sobre libros de literatura, novelas y cuentos.\n\n'
              '• Beneficio presencial válido para alumnos, familias y docentes de la institución durante las clases (${LibreriaConfig.vigenciaConvenio}).\n'
              '• Los manuales escolares de texto no tienen descuento por contar con precio fijado por editorial.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
