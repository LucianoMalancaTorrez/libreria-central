/// "Mi lista": libros para preguntar en el local. Se puede ordenar arrastrando,
/// deslizar para quitar y enviar la lista por WhatsApp.
library;

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/utils/abrir_enlace.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/favoritos/widgets/item_favorito.dart';
import 'package:libreria/presentation/favoritos/widgets/zona_destacar.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late final Future<List<Libro>> _catalogo = Dependencias.of(context).libros
      .getLibros();

  Future<void> _confirmarVaciado() async {
    final favoritos = Dependencias.of(context).favoritos;
    final si = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Vaciar tu lista?'),
        content: const Text('Se quitan todos los libros que guardaste.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vaciar'),
          ),
        ],
      ),
    );
    if (si == true) favoritos.vaciar();
  }

  void _quitar(Libro libro) {
    final favoritos = Dependencias.of(context).favoritos;
    final posicion = favoritos.quitar(libro.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Quitaste "${libro.titulo}"'),
          persist: false,
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () => favoritos.insertar(posicion, libro.id),
          ),
        ),
      );
  }

  void _enviarLista(List<Libro> libros) {
    final detalle = libros.map((l) => '- ${l.titulo} (${l.autor})').join('\n');
    abrirEnlace(
      context,
      LibreriaConfig.enlaceWhatsApp(
        'Hola Amelia! Quisiera ver estos libros en el local:\n$detalle',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = Dependencias.of(context).favoritos;
    return FutureBuilder<List<Libro>>(
      future: _catalogo,
      builder: (context, snapshot) => ListenableBuilder(
        listenable: favoritos,
        builder: (context, _) {
          final porId = {for (final l in snapshot.data ?? <Libro>[]) l.id: l};
          final libros = [
            for (final id in favoritos.ids)
              if (porId[id] != null) porId[id]!,
          ];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mi lista'),
              actions: [
                if (libros.isNotEmpty)
                  IconButton(
                    tooltip: 'Vaciar lista',
                    onPressed: _confirmarVaciado,
                    icon: const Icon(Icons.delete_sweep_outlined),
                  ),
              ],
            ),
            floatingActionButton: libros.isEmpty
                ? null
                : FloatingActionButton.extended(
                    heroTag: 'enviar-lista',
                    onPressed: () => _enviarLista(libros),
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar por WhatsApp'),
                  ),
            body: ResponsiveCenter(child: _contenido(libros)),
          );
        },
      ),
    );
  }

  Widget _contenido(List<Libro> libros) {
    if (libros.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Todavía no guardaste libros.\nTocá el corazón en el catálogo '
            'para armar tu lista y preguntar en el local.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final favoritos = Dependencias.of(context).favoritos;
    return Column(
      children: [
        ZonaDestacar(
          alSoltar: (id) => favoritos.mover(favoritos.ids.indexOf(id), 0),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: libros.length,
            onReorderItem: favoritos.mover,
            itemBuilder: (context, i) => ItemFavorito(
              key: ValueKey(libros[i].id),
              libro: libros[i],
              alQuitar: () => _quitar(libros[i]),
            ),
          ),
        ),
      ],
    );
  }
}
