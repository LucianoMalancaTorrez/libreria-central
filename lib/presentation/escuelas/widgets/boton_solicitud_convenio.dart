import 'package:flutter/material.dart';

class BotonSolicitudConvenio extends StatelessWidget {
  final VoidCallback onTap;

  const BotonSolicitudConvenio({super.key, required this.onTap});

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
