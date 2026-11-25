import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/models/libro.dart';

/// Corazón conectado al estado compartido: se actualiza en todas las pantallas.
class BotonFavorito extends StatelessWidget {
  const BotonFavorito({super.key, required this.libro});

  final Libro libro;

  @override
  Widget build(BuildContext context) {
    final favoritos = Dependencias.of(context).favoritos;
    return ListenableBuilder(
      listenable: favoritos,
      builder: (context, _) {
        final marcado = favoritos.contiene(libro.id);
        return IconButton(
          tooltip: marcado ? 'Quitar de mi lista' : 'Agregar a mi lista',
          onPressed: () => favoritos.alternar(libro.id),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animacion) =>
                ScaleTransition(scale: animacion, child: child),
            child: Icon(
              marcado ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(marcado),
              color: marcado ? AppColors.error : AppColors.leather,
            ),
          ),
        );
      },
    );
  }
}
