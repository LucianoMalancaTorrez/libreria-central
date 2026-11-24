      // lib/screens/informacion_screen.dart
// Cumple los requisitos: horarios de atención (invierno y verano),
// teléfono, dirección, WhatsApp, mapa ("Cómo llegar") e Instagram.
//
// Los datos provienen de HorariosRepository para desacoplar el origen
// de datos (actualmente en memoria local, ampliable a Firestore).

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/horario_atencion.dart';
import '../repositories/app_repositories.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_center.dart';

class InformacionScreen extends StatefulWidget {
  const InformacionScreen({super.key});

  @override
  State<InformacionScreen> createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {
  late Future<List<HorarioAtencion>> _horariosFuture;
  late Future<InfoLibreria> _infoFuture;

  @override
  void initState() {
    super.initState();
    _horariosFuture = AppRepositories.horariosRepository.getHorarios();
    _infoFuture = AppRepositories.horariosRepository.getInfoLibreria();
  }

  Future<void> _abrirWhatsApp(BuildContext context, String telefono) async {
    final uri = Uri.parse(
      'https://wa.me/$telefono?text=${Uri.encodeComponent('Hola Amelia! Quería consultar por un libro en Librería Central.')}',
    );
    await _abrirUrl(context, uri);
  }

  Future<void> _abrirMapa(BuildContext context, String direccion) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(direccion)}',
    );
    await _abrirUrl(context, uri);
  }

  Future<void> _abrirInstagram(BuildContext context, String usuario) async {
    final uri = Uri.parse('https://instagram.com/$usuario');
    await _abrirUrl(context, uri);
  }

  Future<void> _abrirUrl(BuildContext context, Uri uri) async {
    final pudoAbrir = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!pudoAbrir && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información de la librería')),
      body: ResponsiveCenter(
        child: FutureBuilder<InfoLibreria>(
          future: _infoFuture,
          builder: (context, infoSnapshot) {
            final info = infoSnapshot.data ??
                const InfoLibreria(
                  direccion: 'Belgrano 742 (al lado de la farmacia), Mendoza',
                  telefonoWhatsApp: '5492610000000',
                  usuarioInstagram: 'libreriacentral_',
                );

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _Seccion(
                  titulo: 'Horarios de atención',
                  icono: Icons.schedule,
                  child: FutureBuilder<List<HorarioAtencion>>(
                    future: _horariosFuture,
                    builder: (context, horariosSnapshot) {
                      if (horariosSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final horarios = horariosSnapshot.data ?? [];
                      if (horarios.isEmpty) {
                        return const Text('Consultar horarios en el local.');
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: horarios.map((h) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _FilaHorario(
                              temporada: h.temporada,
                              horario: h.horario,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _Seccion(
                  titulo: 'Contacto y ubicación',
                  icono: Icons.call_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FilaDato(
                        icono: Icons.location_on_outlined,
                        texto: info.direccion,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _BotonContacto(
                            icono: Icons.chat_bubble_outline,
                            texto: 'WhatsApp',
                            onTap: () =>
                                _abrirWhatsApp(context, info.telefonoWhatsApp),
                          ),
                          _BotonContacto(
                            icono: Icons.map_outlined,
                            texto: 'Cómo llegar',
                            onTap: () =>
                                _abrirMapa(context, info.direccion),
                          ),
                          _BotonContacto(
                            icono: Icons.camera_alt_outlined,
                            texto: 'Instagram',
                            onTap: () =>
                                _abrirInstagram(context, info.usuarioInstagram),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Widget child;

  const _Seccion({
    required this.titulo,
    required this.icono,
    required this.child,
  });

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
                Icon(icono, color: AppColors.bottleGreen),
                const SizedBox(width: 10),
                Text(titulo, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _FilaHorario extends StatelessWidget {
  final String temporada;
  final String horario;
  const _FilaHorario({required this.temporada, required this.horario});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          temporada,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.leatherDeep,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          horario,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _FilaDato extends StatelessWidget {
  final IconData icono;
  final String texto;
  const _FilaDato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, size: 20, color: AppColors.leather),
        const SizedBox(width: 10),
        Expanded(
          child: Text(texto, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _BotonContacto extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;

  const _BotonContacto({
    required this.icono,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icono, size: 18),
      label: Text(texto),
    );
  }
}
