/// Catálogo de consulta: tapa, título y autor. Sin precios ni stock, porque
/// Amelia quiere que el cliente vaya al local.
library;

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/core/widgets/vista_estado.dart';
import 'package:libreria/presentation/catalogo/viewmodels/catalogo_view_model.dart';
import 'package:libreria/presentation/catalogo/widgets/carrusel_destacados.dart';
import 'package:libreria/presentation/catalogo/widgets/filtros_catalogo.dart';
import 'package:libreria/presentation/catalogo/widgets/menu_orden.dart';
import 'package:libreria/presentation/catalogo/widgets/resultados_catalogo.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  late final CatalogoViewModel _viewModel = CatalogoViewModel(
    Dependencias.of(context).libros,
  )..cargar();
  final _busqueda = TextEditingController();
  late final AppLifecycleListener _cicloDeVida;
  static const _clave = 'ultima_busqueda';

  @override
  void initState() {
    super.initState();
    // Si el sistema cierra la app mientras está oculta, no se pierde nada.
    _cicloDeVida = AppLifecycleListener(onHide: _guardarBusqueda);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recuperarBusqueda());
  }

  Future<void> _guardarBusqueda() =>
      Dependencias.of(context).preferencias
          .guardarLista(_clave, [_busqueda.text]);

  Future<void> _recuperarBusqueda() async {
    final guardada = await Dependencias.of(context).preferencias
        .leerLista(_clave);
    if (!mounted || guardada.isEmpty || _busqueda.text.isNotEmpty) return;
    _busqueda.text = guardada.first;
    _viewModel.buscar(guardada.first);
  }

  @override
  void dispose() {
    _cicloDeVida.dispose();
    _busqueda.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [MenuOrden(viewModel: _viewModel)],
      ),
      body: ResponsiveCenter(
        maxWidth: 900,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _busqueda,
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
                // Slivers: todo se desplaza junto y solo se construye lo visible.
                builder: (context) => CustomScrollView(
                  key: const PageStorageKey('catalogo'),
                  slivers: [
                    SliverToBoxAdapter(
                      child: FiltrosCatalogo(viewModel: _viewModel),
                    ),
                    if (_viewModel.sinFiltros)
                      SliverToBoxAdapter(
                        child: CarruselDestacados(
                          libros: _viewModel.destacados,
                        ),
                      ),
                    ResultadosCatalogo(viewModel: _viewModel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
