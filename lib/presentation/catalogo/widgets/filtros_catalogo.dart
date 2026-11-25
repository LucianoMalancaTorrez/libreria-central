import 'package:flutter/material.dart';
import 'package:libreria/presentation/catalogo/viewmodels/catalogo_view_model.dart';

/// Chips por género y selector de forma de ver el catálogo.
class FiltrosCatalogo extends StatelessWidget {
  const FiltrosCatalogo({super.key, required this.viewModel});

  final CatalogoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final genero in [null, ...viewModel.generos])
                ChoiceChip(
                  label: Text(genero ?? 'Todos'),
                  selected: viewModel.genero == genero,
                  onSelected: (_) => viewModel.filtrarGenero(genero),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SegmentedButton<VistaCatalogo>(
            segments: const [
              ButtonSegment(
                value: VistaCatalogo.grilla,
                icon: Icon(Icons.grid_view),
                label: Text('Tapas'),
              ),
              ButtonSegment(
                value: VistaCatalogo.porGenero,
                icon: Icon(Icons.view_list),
                label: Text('Por género'),
              ),
            ],
            selected: {viewModel.vista},
            onSelectionChanged: (s) => viewModel.cambiarVista(s.first),
          ),
        ],
      ),
    );
  }
}
