import 'package:flutter/material.dart';
import 'package:libreria/core/viewmodels/view_model.dart';

/// Muestra "cargando", "error" o el contenido según el estado del ViewModel.
class VistaEstado extends StatelessWidget {
  const VistaEstado({
    super.key,
    required this.viewModel,
    required this.alReintentar,
    required this.builder,
  });

  final ViewModel viewModel;
  final VoidCallback alReintentar;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.cargando) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = viewModel.error;
        if (error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: alReintentar,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }
        return builder(context);
      },
    );
  }
}
