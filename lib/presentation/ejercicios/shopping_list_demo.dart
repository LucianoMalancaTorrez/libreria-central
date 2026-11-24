/// Actividad de clase: composición con callbacks + ListView, más
/// onLongPress con GestureDetector.
/// Se conserva apartado de la vista principal del cliente.
library;

import 'package:flutter/material.dart';
import 'package:libreria/data/local/libros_mock.dart';
import 'package:libreria/core/theme/app_theme.dart';

/// Clase de datos simple: un producto solo tiene nombre.
class Product {
  const Product({required this.name});
  final String name;
}

/// Firma de la función que ShoppingListItem usa para avisarle
/// a su padre que el usuario tocó el ítem (tap corto).
typedef CartChangedCallback = void Function(Product product, bool inCart);

/// Firma de la función que ShoppingListItem usa para avisar que el
/// usuario mantuvo presionado el ítem (long press).
typedef ProductLongPressCallback = void Function(Product product);

/// Widget HIJO (Stateless): muestra un producto.
class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
    required this.onLongPress,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;
  final ProductLongPressCallback onLongPress;

  Color _getColor(BuildContext context) {
    return inCart
        ? AppColors.leather.withValues(alpha: 0.3)
        : AppColors.bottleGreen;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;
    return TextStyle(
      color: AppColors.leather.withValues(alpha: 0.5),
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onLongPress(product);
      },
      child: ListTile(
        onTap: () {
          onCartChanged(product, inCart);
        },
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: Text(
            product.name[0],
            style: const TextStyle(color: AppColors.parchment),
          ),
        ),
        title: Text(product.name, style: _getTextStyle(context)),
      ),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key, required this.products});

  final List<Product> products;

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _shoppingCart = <Product>{};

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (!inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  void _handleLongPress(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mantuviste presionado "${product.name}"'),
        backgroundColor: AppColors.leatherDeep,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de compras (actividad)')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: widget.products.map((product) {
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
            onLongPress: _handleLongPress,
          );
        }).toList(),
      ),
    );
  }
}

List<Product> productosDeEjemplo() {
  return librosMock.map((libro) => Product(name: libro.titulo)).toList();
}
