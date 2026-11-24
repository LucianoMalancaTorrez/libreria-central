// lib/screens/catalogo_screen.dart
// Muestra el catálogo completo: tapa (placeholder), título y autor.
//
// NOTA (pedido de la clienta): solo se muestra título, autor y tapa,
// "como referencia nomás". Sin precio ni estado de stock, para que no
// se confunda con que se puede comprar desde ahí — ella prefiere que
// el cliente venga al local.
//
// Obtiene los datos a través de LibroRepository para desacoplar el origen
// de datos (memoria local o Firestore en el futuro).

import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../repositories/app_repositories.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_center.dart';
import 'libro_detalle_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  String _busqueda = '';
  List<Libro> _todosLosLibros = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarLibros();
  }

  Future<void> _cargarLibros() async {
    final libros = await AppRepositories.libroRepository.getLibros();
    if (mounted) {
      setState(() {
        _todosLosLibros = libros;
        _cargando = false;
      });
    }
  }

  List<Libro> get _librosFiltrados {
    if (_busqueda.trim().isEmpty) return _todosLosLibros;
    final texto = _busqueda.toLowerCase();
    return _todosLosLibros.where((libro) {
      return libro.titulo.toLowerCase().contains(texto) ||
          libro.autor.toLowerCase().contains(texto) ||
          libro.genero.toLowerCase().contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final libros = _librosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
      ),
      body: ResponsiveCenter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (valor) => setState(() => _busqueda = valor),
                decoration: const InputDecoration(
                  hintText: 'Buscar por título o autor...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : libros.isEmpty
                      ? Center(
                          child: Text(
                            'No se encontraron libros.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: libros.length,
                          itemBuilder: (context, index) {
                            return _TarjetaLibro(libro: libros[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaLibro extends StatelessWidget {
  final Libro libro;
  const _TarjetaLibro({required this.libro});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LibroDetalleScreen(libro: libro)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tapa placeholder: hasta que haya imágenes reales de cada
              // libro, se muestra un ícono sobre fondo de color.
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.leather.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.brass.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: AppColors.leather,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                libro.titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                libro.autor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
