import 'package:flutter/material.dart';

/// Agranda apenas el contenido cuando el mouse pasa por encima.
class ResaltarAlPasar extends StatefulWidget {
  const ResaltarAlPasar({super.key, required this.child});

  final Widget child;

  @override
  State<ResaltarAlPasar> createState() => _ResaltarAlPasarState();
}

class _ResaltarAlPasarState extends State<ResaltarAlPasar> {
  bool _encima = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _encima = true),
      onExit: (_) => setState(() => _encima = false),
      child: AnimatedScale(
        scale: _encima ? 1.03 : 1,
        duration: const Duration(milliseconds: 150),
        child: widget.child,
      ),
    );
  }
}
