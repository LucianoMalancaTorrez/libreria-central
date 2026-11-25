import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libreria/core/plataforma/politicas.dart';
import 'package:libreria/domain/services/fotos.dart';
import 'package:libreria/presentation/admin/viewmodels/foto_view_model.dart';

/// Saca o elige la foto de la tapa.
class SelectorFoto extends StatelessWidget {
  const SelectorFoto({super.key, required this.viewModel});

  final FotoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Column(
        children: [
          if (viewModel.foto.isNotEmpty)
            Image.memory(
              base64Decode(viewModel.foto),
              height: 180,
              gaplessPlayback: true,
              semanticLabel: 'Foto de la tapa',
            ),
          if (viewModel.error != null) Text(viewModel.error!),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: [
              if (const Politicas().ofrecerSacarFoto)
                OutlinedButton.icon(
                  onPressed: () => viewModel.elegir(OrigenFoto.camara),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Sacar foto'),
                ),
              OutlinedButton.icon(
                onPressed: () => viewModel.elegir(OrigenFoto.galeria),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Galería'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
