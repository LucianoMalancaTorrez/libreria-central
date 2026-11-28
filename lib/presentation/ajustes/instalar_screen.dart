import 'package:flutter/material.dart';
import 'package:libreria/core/widgets/responsive_center.dart';

/// Cómo agregar la página al teléfono. En iPhone no aparece ningún cartel.
class InstalarScreen extends StatelessWidget {
  const InstalarScreen({super.key});

  static const _guias = [
    (
      'En iPhone',
      [
        'Abrí esta página con Safari (el ícono de la brújula).',
        'Tocá el botón Compartir: un cuadrado con una flecha hacia arriba.',
        'Elegí "Agregar a inicio" y después "Agregar".',
      ],
    ),
    (
      'En Android',
      [
        'Abrí esta página con Chrome.',
        'Tocá los tres puntitos de arriba a la derecha.',
        'Elegí "Instalar app" o "Agregar a pantalla principal".',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Instalar en el celular')),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final (titulo, pasos) in _guias) ...[
              Text(titulo, style: textos.titleLarge),
              for (final (i, paso) in pasos.indexed)
                ListTile(
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text(paso),
                ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
