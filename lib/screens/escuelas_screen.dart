// lib/screens/escuelas_screen.dart
// Pantalla que lista las escuelas adheridas a convenios con Librería Central.
// Permite acceder a la credencial "Mostrá esto en caja" y solicitar un nuevo
// convenio a través de WhatsApp.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/escuela.dart';
import '../repositories/app_repositories.dart';
import '../repositories/local/in_memory_escuela_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_center.dart';
import 'credencial_escuela_screen.dart';

class EscuelasScreen extends StatefulWidget {
  const EscuelasScreen({super.key});

  @override
  State<EscuelasScreen> createState() => _EscuelasScreenState();
}

class _EscuelasScreenState extends State<EscuelasScreen> {
  late Future<List<Escuela>> _escuelasFuture;

  @override
  void initState() {
    super.initState();
    _cargarEscuelas();
  }

  void _cargarEscuelas() {
    _escuelasFuture = AppRepositories.escuelaRepository.getEscuelas();
  }

  Future<void> _solicitarConvenioWhatsApp(BuildContext context) async {
    const mensaje =
        '¡Hola Amelia! Me comunico para consultar sobre la incorporación de '
        'nuestra escuela al programa de convenios de Librería Central.';
    final uri = Uri.parse(
      'https://wa.me/$kTelefonoWhatsAppEscuelas?text=${Uri.encodeComponent(mensaje)}',
    );

    final pudoAbrir = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!pudoAbrir && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convenios con Escuelas'),
      ),
      body: ResponsiveCenter(
        child: FutureBuilder<List<Escuela>>(
          future: _escuelasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final escuelas = snapshot.data ?? [];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _BannerInformativo(
                  onSolicitarConvenio: () => _solicitarConvenioWhatsApp(context),
                ),
                const SizedBox(height: 20),
                Text(
                  'Escuelas con convenio activo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Si pertenecés a alguna de estas instituciones, seleccioná tu '
                  'escuela para ver la credencial que debés mostrar en caja junto con tu carnet escolar.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                if (escuelas.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No hay escuelas registradas por el momento.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...escuelas.map((escuela) => _TarjetaEscuela(
                        escuela: escuela,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CredencialEscuelaScreen(escuela: escuela),
                          ),
                        ),
                      )),
                const SizedBox(height: 16),
                _BotonSolicitudInferior(
                  onTap: () => _solicitarConvenioWhatsApp(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BannerInformativo extends StatelessWidget {
  final VoidCallback onSolicitarConvenio;

  const _BannerInformativo({required this.onSolicitarConvenio});

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
                    '10% de descuento para tu comunidad escolar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'En Librería Central apoyamos el amor por la lectura. Alumnos, familias '
              'y docentes de escuelas adheridas obtienen 10% de descuento en el local en libros de '
              'literatura, cuentos y novelas durante todo el ciclo lectivo (marzo a diciembre).\n\n'
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

class _TarjetaEscuela extends StatelessWidget {
  final Escuela escuela;
  final VoidCallback onTap;

  const _TarjetaEscuela({
    required this.escuela,
    required this.onTap,
  });

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
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
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonSolicitudInferior extends StatelessWidget {
  final VoidCallback onTap;

  const _BotonSolicitudInferior({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.chat_bubble_outline, size: 20),
          label: const Text('¿Tu escuela no figura? Escribinos por WhatsApp'),
        ),
      ),
    );
  }
}
