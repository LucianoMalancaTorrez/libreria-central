/// Ejercicio de clase: Ciclo de vida + animaciones implícitas.
/// Se conserva apartado de la vista principal del cliente.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:libreria/data/local/libros_mock.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/core/theme/app_theme.dart';

class ProductoCardDemoPage extends StatelessWidget {
  const ProductoCardDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad: ProductoCard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: librosMock
            .map(
              (libro) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProductoCard(libro: libro),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ProductoCard extends StatefulWidget {
  const ProductoCard({super.key, required this.libro});

  final Libro libro;

  @override
  State<ProductoCard> createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  Timer? _timer;
  int _segundosVisto = 0;

  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _segundosVisto++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleFavorito() {
    setState(() {
      _esFavorito = !_esFavorito;
    });
  }

  @override
  Widget build(BuildContext context) {
    final libro = widget.libro;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _esFavorito
            ? AppColors.brass.withValues(alpha: 0.25)
            : AppColors.parchmentDeep,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _esFavorito
              ? AppColors.brass
              : AppColors.brass.withValues(alpha: 0.4),
          width: _esFavorito ? 1.6 : 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.leather.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.leather,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  libro.titulo,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  libro.autor,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Visto hace $_segundosVisto s',
                    key: ValueKey<int>(_segundosVisto),
                    style: AppTheme.stampLabel(),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _toggleFavorito,
            icon: Icon(
              _esFavorito ? Icons.favorite : Icons.favorite_border,
              color: _esFavorito ? AppColors.error : AppColors.leather,
            ),
          ),
        ],
      ),
    );
  }
}
