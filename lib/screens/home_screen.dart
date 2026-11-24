// lib/screens/home_screen.dart
// Pantalla principal de "Librería Central Winterbach" («lo de Amelia»).
// Presenta las secciones clave del negocio acordadas con Amelia:
// Catálogo de consulta, Convenios con escuelas, Información y Nuestra historia.
// Las actividades académicas de clase se conservan en un menú lateral discreto.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_center.dart';
import 'catalogo_screen.dart';
import 'escuelas_screen.dart';
import 'historia_screen.dart';
import 'informacion_screen.dart';
import 'ejercicios/producto_card_demo.dart';
import 'ejercicios/shopping_list_demo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Librería Central Winterbach',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '«lo de Amelia»',
              style: AppTheme.stampLabel(color: AppColors.bottleGreenDark).copyWith(
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      endDrawer: _MenuEjerciciosDrawer(),
      body: ResponsiveCenter(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Buscador(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CatalogoScreen()),
                ),
              ),
              const SizedBox(height: 20),

              // Catálogo: libros disponibles para consulta presencial (sin precios)
              _TarjetaAccion(
                icono: Icons.menu_book_rounded,
                titulo: 'Catálogo',
                subtitulo: 'Consultar libros disponibles en el local',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CatalogoScreen()),
                ),
              ),
              const SizedBox(height: 16),

              // Convenios con escuelas: beneficio y credencial para canje en caja
              _TarjetaAccion(
                icono: Icons.school_outlined,
                titulo: 'Convenios con escuelas',
                subtitulo: '10% en literatura para Colegios San José, Sarmiento y más',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EscuelasScreen()),
                ),
              ),
              const SizedBox(height: 16),

              // Información: horarios, teléfono, WhatsApp, mapa e Instagram
              _TarjetaAccion(
                icono: Icons.info_outline_rounded,
                titulo: 'Información de la librería',
                subtitulo: 'Belgrano 742, horarios invierno/verano y contacto',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InformacionScreen()),
                ),
              ),
              const SizedBox(height: 16),

              // Nuestra historia: tradición familiar de tres generaciones
              _TarjetaAccion(
                icono: Icons.auto_stories_outlined,
                titulo: 'Nuestra historia',
                subtitulo: 'Desde 1952 con Otto, Ernesto y Amelia',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoriaScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Buscador extends StatelessWidget {
  final VoidCallback onTap;
  const _Buscador({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.parchmentDeep,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.brass.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.leather),
            const SizedBox(width: 10),
            Text(
              'Buscar en el catálogo...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.leather.withValues(alpha: 0.55),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaAccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _TarjetaAccion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icono, color: AppColors.bottleGreen, size: 32),
        title: Text(
          titulo,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.chevron_right, color: AppColors.leather),
        onTap: onTap,
      ),
    );
  }
}

/// Menú lateral discreto para que la profesora pueda evaluar las actividades
/// de clase sin interferir en la experiencia mostrable a la clienta.
class _MenuEjerciciosDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.parchment,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Actividades de clase',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Ejercicios prácticos de la materia de desarrollo móvil.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.bottleGreen),
              title: const Text('Actividad: Lista de compras'),
              subtitle: const Text('Composición + onLongPress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShoppingListPage(products: productosDeEjemplo()),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation, color: AppColors.bottleGreen),
              title: const Text('Actividad: ProductoCard'),
              subtitle: const Text('Ciclo de vida y animaciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductoCardDemoPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
