import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/presentation/ejercicios/producto_card_demo.dart';
import 'package:libreria/presentation/ejercicios/shopping_list_demo.dart';

/// Menú lateral discreto para que la profesora pueda evaluar las actividades
/// de clase sin interferir en la experiencia mostrable a la clienta.
class MenuEjerciciosDrawer extends StatelessWidget {
  const MenuEjerciciosDrawer({super.key});

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
              leading: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.bottleGreen,
              ),
              title: const Text('Actividad: Lista de compras'),
              subtitle: const Text('Composición + onLongPress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ShoppingListPage(products: productosDeEjemplo()),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.animation,
                color: AppColors.bottleGreen,
              ),
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
