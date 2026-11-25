// lib/widgets/responsive_center.dart
//
// Ahora que el proyecto compila también a web, alguien puede abrir el
// sitio desde una computadora con una pantalla ancha. Este widget
// centra el contenido y le pone un ancho máximo, para que no se vea
// todo estirado. En un celular no cambia nada, porque el ancho de
// pantalla ya es menor al máximo definido acá.

import 'package:flutter/material.dart';

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child, this.maxWidth = 480});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // SafeArea: nada queda tapado por la cámara o los bordes redondeados.
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
