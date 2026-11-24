import 'package:flutter/material.dart';

class BotonContacto extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;

  const BotonContacto({
    super.key,
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
