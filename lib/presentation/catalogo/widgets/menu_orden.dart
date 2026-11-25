import 'package:flutter/material.dart';
import 'package:libreria/presentation/catalogo/viewmodels/catalogo_view_model.dart';

/// Menú de la barra superior para elegir el orden del catálogo.
class MenuOrden extends StatelessWidget {
  const MenuOrden({super.key, required this.viewModel});

  final CatalogoViewModel viewModel;

  static const _opciones = {
    OrdenCatalogo.original: 'Orden de la librería',
    OrdenCatalogo.titulo: 'Por título',
    OrdenCatalogo.autor: 'Por autor',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => MenuAnchor(
        menuChildren: [
          for (final MapEntry(key: orden, value: texto) in _opciones.entries)
            RadioMenuButton<OrdenCatalogo>(
              value: orden,
              groupValue: viewModel.orden,
              onChanged: (o) => viewModel.ordenar(o!),
              child: Text(texto),
            ),
        ],
        builder: (context, controlador, _) => IconButton(
          tooltip: 'Ordenar',
          icon: const Icon(Icons.sort),
          onPressed: () =>
              controlador.isOpen ? controlador.close() : controlador.open(),
        ),
      ),
    );
  }
}
