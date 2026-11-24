/// Catálogo de consulta: tapa, título y autor. Sin precios ni stock, porque
/// Amelia quiere que el cliente vaya al local.
library;

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/core/widgets/vista_estado.dart';
import 'package:libreria/presentation/catalogo/viewmodels/catalogo_view_model.dart';
import 'package:libreria/presentation/catalogo/widgets/tarjeta_libro.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  late final CatalogoViewModel _viewModel = CatalogoViewModel(
    Dependencias.of(context).libros,
  )..cargar();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: ResponsiveCenter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: _viewModel.buscar,
                decoration: const InputDecoration(
                  hintText: 'Buscar por título o autor...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: VistaEstado(
                viewModel: _viewModel,
                alReintentar: _viewModel.cargar,
                builder: _grilla,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grilla(BuildContext context) {
    final libros = _viewModel.libros;
    if (libros.isEmpty) {
      return const Center(child: Text('No se encontraron libros.'));
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: libros.length,
      itemBuilder: (context, index) => TarjetaLibro(libro: libros[index]),
    );
  }
}
