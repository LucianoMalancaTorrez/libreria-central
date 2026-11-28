import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/catalogo/widgets/tarjeta_libro.dart';
import 'package:libreria/presentation/comun/tapa_libro.dart';

/// Fila de "Mi lista": se desliza para quitar y la tapa se puede arrastrar.
class ItemFavorito extends StatelessWidget {
  const ItemFavorito({super.key, required this.libro, required this.alQuitar});

  final Libro libro;
  final VoidCallback alQuitar;

  @override
  Widget build(BuildContext context) {
    final tapa = SizedBox(
      width: 36,
      height: 48,
      child: TapaLibro(libro: libro),
    );
    return Dismissible(
      key: ValueKey('quitar-${libro.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => alQuitar(),
      background: Container(
        color: context.colores.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(Icons.delete, color: context.colores.parchment),
      ),
      child: ListTile(
        leading: Draggable<String>(
          data: libro.id,
          feedback: Material(color: Colors.transparent, child: tapa),
          childWhenDragging: Opacity(opacity: 0.3, child: tapa),
          child: tapa,
        ),
        title: Text(libro.titulo),
        subtitle: Text(libro.autor),
        onTap: () => abrirDetalle(context, libro),
      ),
    );
  }
}
