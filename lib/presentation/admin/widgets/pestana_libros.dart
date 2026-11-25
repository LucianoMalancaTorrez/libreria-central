import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/tapa_libro.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/admin/libro_form_screen.dart';

class PestanaLibros extends StatefulWidget {
  const PestanaLibros({super.key});

  @override
  State<PestanaLibros> createState() => _PestanaLibrosState();
}

class _PestanaLibrosState extends State<PestanaLibros> {
  late final Stream<List<Libro>> _libros = Dependencias.of(context)
      .administracion!
      .catalogo
      .observarPublicados();
  bool _importando = false;

  void _editar([Libro? libro]) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LibroFormScreen(libro: libro)),
  );

  Future<void> _eliminar(Libro libro) async {
    final administracion = Dependencias.of(context).administracion!;
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
    try {
      await administracion.catalogo.eliminar(libro.id);
    } catch (e) {
      debugPrint('Borrar: $e');
      mensajero.showSnackBar(
        const SnackBar(content: Text('No se pudo borrar.')),
      );
    }
  }

  Future<void> _importar() async {
    final administracion = Dependencias.of(context).administracion!;
    final mensajero = ScaffoldMessenger.of(context);
    setState(() => _importando = true);
    var mensaje = 'Catálogo de ejemplo cargado en la nube.';
    try {
      final ejemplo = await administracion.catalogoDeEjemplo
          .observarLibros()
          .first;
      await administracion.catalogo.importar(ejemplo);
    } catch (e) {
      debugPrint('Importar: $e');
      mensaje = 'No se pudo cargar el catálogo.';
    }
    if (mounted) setState(() => _importando = false);
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
      body: StreamBuilder<List<Libro>>(
        stream: _libros,
        builder: (context, snapshot) {
          final libros = snapshot.data;
          if (libros == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: libros.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) return _cabecera();
              final libro = libros[i - 1];
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
          );
        },
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
        if (_importando)
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
