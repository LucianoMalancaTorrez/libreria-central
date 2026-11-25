import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/services/info_libro_service.dart';

/// Tapa y año de la primera edición, pedidos a una API pública.
class InfoExternaLibro extends StatefulWidget {
  const InfoExternaLibro({super.key, required this.libro});

  final Libro libro;

  @override
  State<InfoExternaLibro> createState() => _InfoExternaLibroState();
}

class _InfoExternaLibroState extends State<InfoExternaLibro> {
  Future<InfoExterna?>? _pedido;

  Future<InfoExterna?> _pedir() =>
      Dependencias.of(context).infoLibros
          .buscar(widget.libro.titulo, widget.libro.autor);

  // Primer lugar del ciclo de vida donde se puede usar el context heredado.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pedido ??= _pedir();
  }

  // Si el mismo widget pasa a mostrar otro libro, se vuelve a pedir.
  @override
  void didUpdateWidget(InfoExternaLibro oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.libro.id != widget.libro.id) _pedido = _pedir();
  }

  Widget _sinTapa() => const Icon(Icons.menu_book_rounded, size: 72);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InfoExterna?>(
      future: _pedido,
      builder: (context, snapshot) {
        final info = snapshot.data;
        final url = info?.urlTapa;
        return Column(
          children: [
            SizedBox(
              height: 220,
              child: Center(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator()
                    : url == null
                    ? _sinTapa()
                    : Image.network(
                        url,
                        semanticLabel: 'Tapa de ${widget.libro.titulo}',
                        errorBuilder: (_, _, _) => _sinTapa(),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            if (snapshot.hasError)
              const Text('No se pudo buscar la tapa. Revisá tu conexión.'),
            if (info?.primeraEdicion != null)
              Text('Primera edición: ${info!.primeraEdicion}'),
            if (url != null)
              Text(
                'Tapa de referencia: Open Library',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        );
      },
    );
  }
}
