import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/presentation/catalogo/viewmodels/catalogo_view_model.dart';
import 'package:libreria/presentation/catalogo/widgets/boton_favorito.dart';
import 'package:libreria/presentation/catalogo/widgets/tarjeta_libro.dart';

/// Resultados como grilla adaptable o como lista con encabezados por género.
class ResultadosCatalogo extends StatelessWidget {
  const ResultadosCatalogo({super.key, required this.viewModel});

  final CatalogoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.libros.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text('No se encontraron libros.')),
      );
    }

    if (viewModel.vista == VistaCatalogo.grilla) {
      final libros = viewModel.libros;
      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            // Con letra grande las tarjetas crecen y no se cortan.
            mainAxisExtent: MediaQuery.textScalerOf(context).scale(90) + 160,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: libros.length,
          itemBuilder: (context, i) => TarjetaLibro(libro: libros[i]),
        ),
      );
    }

    final filas = viewModel.filas;
    return SliverList.builder(
      itemCount: filas.length,
      itemBuilder: (context, i) => switch (filas[i]) {
        FilaEncabezado(:final genero) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Text(
            genero,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: AppColors.bottleGreenDark),
          ),
        ),
        FilaLibro(:final libro) => ListTile(
          leading: const Icon(Icons.menu_book_rounded),
          title: Text(libro.titulo),
          subtitle: Text(libro.autor),
          trailing: BotonFavorito(libro: libro),
          onTap: () => abrirDetalle(context, libro),
        ),
      },
    );
  }
}
