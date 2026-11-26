import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/tapa_libro.dart';
import 'package:libreria/core/widgets/vista_estado.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/admin/libro_form_screen.dart';
import 'package:libreria/presentation/admin/viewmodels/libros_admin_view_model.dart';

/// Solo dibuja y pregunta; las decisiones están en el ViewModel.
class PestanaLibros extends StatefulWidget {
  const PestanaLibros({super.key});

  @override
  State<PestanaLibros> createState() => _PestanaLibrosState();
}

class _PestanaLibrosState extends State<PestanaLibros> {
  late final LibrosAdminViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final admin = Dependencias.of(context).administracion!;
    _viewModel = LibrosAdminViewModel(admin.catalogo, admin.catalogoDeEjemplo)
      ..cargar();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _editar([Libro? libro]) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LibroFormScreen(libro: libro)),
  );

  Future<void> _eliminar(Libro libro) async {
    final mensajero = ScaffoldMessenger.of(context);
    final si = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Borrar este libro?'),
        content: Text(libro.titulo),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (si != true) return;
    final error = await _viewModel.eliminar(libro);
    if (error != null) {
      mensajero.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _importar() async {
    final mensajero = ScaffoldMessenger.of(context);
    final mensaje = await _viewModel.importar();
    mensajero.showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'nuevo-libro',
        onPressed: _editar,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo libro'),
      ),
      body: VistaEstado(
        viewModel: _viewModel,
        alReintentar: _viewModel.cargar,
        builder: (context) => ListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: _viewModel.libros.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return _cabecera();
            final libro = _viewModel.libros[i - 1];
            return ListTile(
              leading: SizedBox(width: 40, child: TapaLibro(libro: libro)),
              title: Text(libro.titulo),
              subtitle: Text(libro.autor),
              onTap: () => _editar(libro),
              trailing: IconButton(
                tooltip: 'Borrar ${libro.titulo}',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _eliminar(libro),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _cabecera() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'La primera vez, cargá el catálogo de ejemplo para poder '
          'editarlo. Pisa los libros de ejemplo que hayas cambiado.',
        ),
        const SizedBox(height: 8),
        if (_viewModel.importando)
          const LinearProgressIndicator()
        else
          OutlinedButton.icon(
            onPressed: _importar,
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Cargar catálogo de ejemplo'),
          ),
      ],
    ),
  );
}
