/// Alta y edición de un libro, con foto de la tapa.
library;

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/admin/viewmodels/foto_view_model.dart';
import 'package:libreria/presentation/admin/widgets/selector_foto.dart';

const generosDisponibles = [
  'Novela',
  'Cuento',
  'Infantil',
  'Aventura',
  'Poesía',
  'Policial',
  'Otro',
];

class LibroFormScreen extends StatefulWidget {
  const LibroFormScreen({super.key, this.libro});

  /// null para un libro nuevo.
  final Libro? libro;

  @override
  State<LibroFormScreen> createState() => _LibroFormScreenState();
}

class _LibroFormScreenState extends State<LibroFormScreen> {
  final _formulario = GlobalKey<FormState>();
  late final _titulo = TextEditingController(text: widget.libro?.titulo);
  late final _autor = TextEditingController(text: widget.libro?.autor);
  late final _descripcion = TextEditingController(
    text: widget.libro?.descripcion,
  );
  late String _genero = widget.libro?.genero ?? generosDisponibles.first;
  late final FotoViewModel _fotos;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final servicios = Dependencias.of(context);
    _fotos = FotoViewModel(
      servicios.fotos,
      servicios.borradorFoto,
      clave: widget.libro?.id ?? 'nuevo',
      inicial: widget.libro?.foto ?? '',
    )..recuperar();
  }

  @override
  void dispose() {
    _fotos.dispose();
    _titulo.dispose();
    _autor.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formulario.currentState!.validate()) return;
    final catalogo = Dependencias.of(context).administracion!.catalogo;
    final mensajero = ScaffoldMessenger.of(context);
    final navegador = Navigator.of(context);
    setState(() => _guardando = true);
    try {
      await catalogo.guardar(
        Libro(
          id: widget.libro?.id ?? '',
          titulo: _titulo.text.trim(),
          autor: _autor.text.trim(),
          genero: _genero,
          editorial: widget.libro?.editorial ?? '',
          descripcion: _descripcion.text.trim(),
          foto: _fotos.foto,
        ),
      );
      await _fotos.descartarBorrador();
      if (mounted) navegador.pop();
      mensajero.showSnackBar(const SnackBar(content: Text('Guardado')));
    } catch (e) {
      debugPrint('Guardar: $e');
      if (mounted) setState(() => _guardando = false);
      mensajero.showSnackBar(
        const SnackBar(content: Text('No se pudo guardar.')),
      );
    }
  }

  String? _obligatorio(String? valor) =>
      (valor ?? '').trim().isEmpty ? 'Completá este dato' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.libro == null ? 'Nuevo libro' : 'Editar libro'),
      ),
      body: ResponsiveCenter(
        child: Form(
          key: _formulario,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SelectorFoto(viewModel: _fotos),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titulo,
                  maxLength: 200,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: _obligatorio,
                ),
                TextFormField(
                  controller: _autor,
                  maxLength: 200,
                  decoration: const InputDecoration(labelText: 'Autor'),
                  validator: _obligatorio,
                ),
                DropdownButtonFormField<String>(
                  initialValue: _genero,
                  decoration: const InputDecoration(labelText: 'Género'),
                  items: [
                    for (final g in {...generosDisponibles, _genero})
                      DropdownMenuItem(value: g, child: Text(g)),
                  ],
                  onChanged: (g) => _genero = g ?? _genero,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descripcion,
                  maxLength: 2000,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_guardando ? 'Guardando...' : 'Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
