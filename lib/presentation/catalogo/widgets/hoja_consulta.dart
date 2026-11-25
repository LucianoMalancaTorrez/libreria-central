import 'package:flutter/material.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/utils/abrir_enlace.dart';
import 'package:libreria/domain/models/libro.dart';

/// Panel inferior para consultar por un libro por WhatsApp.
Future<void> mostrarHojaConsulta(BuildContext context, Libro libro) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _HojaConsulta(libro: libro),
    );

class _HojaConsulta extends StatefulWidget {
  const _HojaConsulta({required this.libro});

  final Libro libro;

  @override
  State<_HojaConsulta> createState() => _HojaConsultaState();
}

class _HojaConsultaState extends State<_HojaConsulta> {
  final _nombre = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  void _enviar() {
    final nombre = _nombre.text.trim();
    final saludo = nombre.isEmpty
        ? 'Hola Amelia!'
        : 'Hola Amelia! Soy $nombre.';
    abrirEnlace(
      context,
      LibreriaConfig.enlaceWhatsApp(
        '$saludo Quería consultar por "${widget.libro.titulo}" '
        'de ${widget.libro.autor}.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Deja lugar al teclado.
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Consultar por "${widget.libro.titulo}"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombre,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Tu nombre (opcional)',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _enviar,
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Preguntar por WhatsApp'),
          ),
        ],
      ),
    );
  }
}
