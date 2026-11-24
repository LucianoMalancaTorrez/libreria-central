/// Escuelas adheridas, con acceso a la credencial para mostrar en caja.
library;

import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/utils/abrir_enlace.dart';
import 'package:libreria/core/widgets/vista_estado.dart';
import 'package:libreria/presentation/escuelas/viewmodels/escuelas_view_model.dart';
import 'package:flutter/material.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/escuelas/credencial_escuela_screen.dart';
import 'package:libreria/presentation/escuelas/widgets/banner_convenio.dart';
import 'package:libreria/presentation/escuelas/widgets/boton_solicitud_convenio.dart';
import 'package:libreria/presentation/escuelas/widgets/tarjeta_escuela.dart';

class EscuelasScreen extends StatefulWidget {
  const EscuelasScreen({super.key});

  @override
  State<EscuelasScreen> createState() => _EscuelasScreenState();
}

class _EscuelasScreenState extends State<EscuelasScreen> {
  late final EscuelasViewModel _viewModel = EscuelasViewModel(
    Dependencias.of(context).escuelas,
  )..cargar();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _solicitarConvenio() {
    abrirEnlace(
      context,
      LibreriaConfig.enlaceWhatsApp(
        '¡Hola Amelia! Me comunico para consultar sobre la incorporación de '
        'nuestra escuela al programa de convenios de Librería Central.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Convenios con Escuelas')),
      body: ResponsiveCenter(
        child: VistaEstado(
          viewModel: _viewModel,
          alReintentar: _viewModel.cargar,
          builder: _lista,
        ),
      ),
    );
  }

  Widget _lista(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final escuelas = _viewModel.escuelas;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BannerConvenio(onSolicitarConvenio: _solicitarConvenio),
        const SizedBox(height: 20),
        Text('Escuelas con convenio activo', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Si pertenecés a alguna de estas instituciones, seleccioná tu '
          'escuela para ver la credencial que debés mostrar en caja junto '
          'con tu carnet escolar.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (escuelas.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text('No hay escuelas registradas por el momento.'),
            ),
          ),
        for (final escuela in escuelas)
          TarjetaEscuela(
            escuela: escuela,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CredencialEscuelaScreen(escuela: escuela),
              ),
            ),
          ),
        const SizedBox(height: 16),
        BotonSolicitudConvenio(onTap: _solicitarConvenio),
      ],
    );
  }
}
