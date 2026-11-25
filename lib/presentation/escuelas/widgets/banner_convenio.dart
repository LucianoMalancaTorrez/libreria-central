import 'package:flutter/material.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/theme/app_theme.dart';

class BannerConvenio extends StatelessWidget {
  final VoidCallback onSolicitarConvenio;

  const BannerConvenio({super.key, required this.onSolicitarConvenio});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.parchmentDeep,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  color: AppColors.bottleGreen,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${LibreriaConfig.descuentoEscolar}% de descuento para tu comunidad escolar',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'En Librería Central apoyamos el amor por la lectura. Alumnos, familias '
              'y docentes de escuelas adheridas obtienen ${LibreriaConfig.descuentoEscolar}% de descuento en el local en libros de '
              'literatura, cuentos y novelas durante todo el ciclo lectivo (${LibreriaConfig.vigenciaConvenio}).\n\n'
              'Nota: Los manuales escolares de texto no aplican al descuento por tener precio fijado por editorial.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSolicitarConvenio,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Quiero que mi escuela tenga convenio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
