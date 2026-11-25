/// Resto de las secciones y las preferencias de accesibilidad.
library;

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/admin/admin_screen.dart';
import 'package:libreria/presentation/ajustes/privacidad_screen.dart';
import 'package:libreria/presentation/ajustes/widgets/control_letra.dart';
import 'package:libreria/presentation/escuelas/escuelas_screen.dart';
import 'package:libreria/presentation/eventos/eventos_screen.dart';
import 'package:libreria/presentation/historia/historia_screen.dart';
import 'package:libreria/presentation/informacion/informacion_screen.dart';

class MasScreen extends StatelessWidget {
  const MasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final servicios = Dependencias.of(context);
    final secciones = <(IconData, String, Widget)>[
      (Icons.event, 'Club de lectura', const EventosScreen()),
      (Icons.school_outlined, 'Convenios con escuelas', const EscuelasScreen()),
      (Icons.info_outline, 'Horarios y contacto', const InformacionScreen()),
      (Icons.auto_stories_outlined, 'Nuestra historia', const HistoriaScreen()),
      (
        Icons.privacy_tip_outlined,
        'Privacidad y permisos',
        const PrivacidadScreen(),
      ),
      if (servicios.administracion != null)
        (Icons.lock_outline, 'Administración', const AdminScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Más')),
      body: ResponsiveCenter(
        child: ListView(
          children: [
            ControlLetra(ajustes: servicios.ajustes),
            const Divider(),
            for (final (icono, titulo, pantalla) in secciones)
              ListTile(
                leading: Icon(icono),
                title: Text(titulo),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => pantalla),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
