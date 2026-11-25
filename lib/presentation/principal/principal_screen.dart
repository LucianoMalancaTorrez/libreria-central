/// Estructura principal: barra de navegación abajo en el celular y al costado
/// en pantallas anchas.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/aviso_sin_conexion.dart';
import 'package:libreria/core/widgets/tamano_ventana.dart';
import 'package:libreria/presentation/ajustes/mas_screen.dart';
import 'package:libreria/presentation/catalogo/catalogo_screen.dart';
import 'package:libreria/presentation/favoritos/favoritos_screen.dart';
import 'package:libreria/presentation/inicio/home_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _indice = 0;

  void _irA(int indice) => setState(() => _indice = indice);

  @override
  Widget build(BuildContext context) {
    final favoritos = Dependencias.of(context).favoritos;
    final tamano = tamanoDeVentana(MediaQuery.sizeOf(context).width);
    final ancho = tamano != TamanoVentana.compacta;
    final extendida = tamano == TamanoVentana.expandida;

    Widget iconoLista(IconData icono) => ListenableBuilder(
      listenable: favoritos,
      builder: (context, _) => Badge.count(
        count: favoritos.cantidad,
        isLabelVisible: favoritos.cantidad > 0,
        child: Icon(icono),
      ),
    );

    final destinos = <(Widget, Widget, String)>[
      (const Icon(Icons.home_outlined), const Icon(Icons.home), 'Inicio'),
      (
        const Icon(Icons.menu_book_outlined),
        const Icon(Icons.menu_book),
        'Catálogo',
      ),
      (
        iconoLista(Icons.favorite_border),
        iconoLista(Icons.favorite),
        'Mi lista',
      ),
      (const Icon(Icons.more_horiz), const Icon(Icons.more_horiz), 'Más'),
    ];

    final contenido = Column(
      children: [
        const AvisoSinConexion(),
        Expanded(
          // IndexedStack conserva la búsqueda y el scroll de cada pestaña.
          child: IndexedStack(
            index: _indice,
            children: [
              HomeScreen(alAbrirCatalogo: () => _irA(1)),
              const CatalogoScreen(),
              const FavoritosScreen(),
              const MasScreen(),
            ],
          ),
        ),
      ],
    );

    final pantalla = Scaffold(
      body: ancho
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _indice,
                  onDestinationSelected: _irA,
                  extended: extendida,
                  labelType: extendida
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: [
                    for (final (icono, activo, texto) in destinos)
                      NavigationRailDestination(
                        icon: icono,
                        selectedIcon: activo,
                        label: Text(texto),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: contenido),
              ],
            )
          : contenido,
      bottomNavigationBar: ancho
          ? null
          : NavigationBar(
              selectedIndex: _indice,
              onDestinationSelected: _irA,
              destinations: [
                for (final (icono, activo, texto) in destinos)
                  NavigationDestination(
                    icon: icono,
                    selectedIcon: activo,
                    label: texto,
                  ),
              ],
            ),
    );

    // Atajos Ctrl+1 a Ctrl+4 para usar la app con teclado.
    const teclas = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
    ];
    return CallbackShortcuts(
      bindings: {
        for (var i = 0; i < teclas.length; i++)
          SingleActivator(teclas[i], control: true): () => _irA(i),
      },
      child: Focus(autofocus: true, child: pantalla),
    );
  }
}
