/// Detalle de un libro, sin precio ni stock: la app es de consulta.
library;

import 'package:libreria/core/widgets/tapa_libro.dart';
import 'package:flutter/material.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/catalogo/widgets/boton_favorito.dart';
import 'package:libreria/presentation/catalogo/widgets/dato_libro.dart';
import 'package:libreria/presentation/catalogo/widgets/hoja_consulta.dart';
import 'package:libreria/presentation/catalogo/widgets/info_externa_libro.dart';

class LibroDetalleScreen extends StatelessWidget {
  const LibroDetalleScreen({super.key, required this.libro});

  final Libro libro;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titulo),
        actions: [BotonFavorito(libro: libro)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => mostrarHojaConsulta(context, libro),
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Consultar'),
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
          children: [
            // Si hay foto propia no hace falta consultar afuera.
            if (libro.foto.isEmpty)
              InfoExternaLibro(libro: libro)
            else
              SizedBox(height: 220, child: TapaLibro(libro: libro)),
            const SizedBox(height: 20),
            Text(libro.titulo, style: textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(libro.autor, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DatoLibro(label: 'Género', valor: libro.genero),
                if (libro.editorial.isNotEmpty)
                  DatoLibro(label: 'Editorial', valor: libro.editorial),
              ],
            ),
            if (libro.descripcion.isNotEmpty) ...[
              const Divider(height: 40),
              Text('Descripción', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(libro.descripcion, style: textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }
}
