/// Resto de las secciones y las preferencias de accesibilidad.
library;

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/ajustes/privacidad_screen.dart';
import 'package:libreria/presentation/escuelas/escuelas_screen.dart';
import 'package:libreria/presentation/eventos/eventos_screen.dart';
import 'package:libreria/presentation/historia/historia_screen.dart';
import 'package:libreria/presentation/informacion/informacion_screen.dart';

class MasScreen extends StatelessWidget {
  const MasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ajustes = Dependencias.of(context).ajustes;
    const secciones = <(IconData, String, Widget)>[
      (Icons.event, 'Club de lectura', EventosScreen()),
      (Icons.school_outlined, 'Convenios con escuelas', EscuelasScreen()),
      (Icons.info_outline, 'Horarios y contacto', InformacionScreen()),
      (Icons.auto_stories_outlined, 'Nuestra historia', HistoriaScreen()),
      (Icons.privacy_tip_outlined, 'Privacidad y permisos', PrivacidadScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Más')),
      body: ResponsiveCenter(
        child: ListView(
          children: [
            ListenableBuilder(
              listenable: ajustes,
              builder: (context, _) => SwitchListTile(
                secondary: const Icon(Icons.format_size),
                title: const Text('Letra grande'),
                value: ajustes.letraGrande,
                onChanged: ajustes.cambiarLetraGrande,
              ),
            ),
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
