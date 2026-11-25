/// Horarios, dirección, WhatsApp, mapa e Instagram.
library;

import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/utils/abrir_enlace.dart';
import 'package:libreria/core/widgets/vista_estado.dart';
import 'package:libreria/presentation/informacion/viewmodels/informacion_view_model.dart';
import 'package:flutter/material.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/informacion/widgets/boton_contacto.dart';
import 'package:libreria/presentation/informacion/widgets/fila_dato.dart';
import 'package:libreria/presentation/informacion/widgets/fila_horario.dart';
import 'package:libreria/presentation/informacion/widgets/seccion_info.dart';

class InformacionScreen extends StatefulWidget {
  const InformacionScreen({super.key});

  @override
  State<InformacionScreen> createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {
  late final InformacionViewModel _viewModel = InformacionViewModel(
    Dependencias.of(context).horarios,
  )..cargar();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información de la librería')),
      body: ResponsiveCenter(
        child: VistaEstado(
          viewModel: _viewModel,
          alReintentar: _viewModel.cargar,
          builder: _contenido,
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    final info = _viewModel.info!;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SeccionInfo(
          titulo: 'Horarios de atención',
          icono: Icons.schedule,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (temporada, horario) in [
                ('Invierno (abril a octubre)', _viewModel.horarios.invierno),
                ('Verano (octubre a abril)', _viewModel.horarios.verano),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FilaHorario(
                    temporada: temporada,
                    horario: horario.texto,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SeccionInfo(
          titulo: 'Contacto y ubicación',
          icono: Icons.call_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilaDato(
                icono: Icons.location_on_outlined,
                texto: info.direccion,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  BotonContacto(
                    icono: Icons.chat_bubble_outline,
                    texto: 'WhatsApp',
                    onTap: () => abrirEnlace(
                      context,
                      LibreriaConfig.enlaceWhatsApp(
                        'Hola Amelia! Quería consultar por un libro en '
                        'Librería Central.',
                      ),
                    ),
                  ),
                  BotonContacto(
                    icono: Icons.map_outlined,
                    texto: 'Cómo llegar',
                    onTap: () => abrirEnlace(
                      context,
                      LibreriaConfig.enlaceMapa(info.direccion),
                    ),
                  ),
                  BotonContacto(
                    icono: Icons.camera_alt_outlined,
                    texto: 'Instagram',
                    onTap: () => abrirEnlace(
                      context,
                      LibreriaConfig.enlaceInstagram(info.usuarioInstagram),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
