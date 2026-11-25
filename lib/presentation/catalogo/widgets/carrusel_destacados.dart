import 'package:flutter/material.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/presentation/catalogo/widgets/tarjeta_libro.dart';

/// Lista horizontal con algunos libros destacados.
class CarruselDestacados extends StatelessWidget {
  const CarruselDestacados({super.key, required this.libros});

  final List<Libro> libros;

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.textScalerOf(context).scale(90) + 140;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'Destacados',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: alto,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: libros.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) =>
                SizedBox(width: 160, child: TarjetaLibro(libro: libros[i])),
          ),
        ),
      ],
    );
  }
}
