import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/presentation/inicio/home_screen.dart';

class LibreriaApp extends StatelessWidget {
  const LibreriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependencias va por encima de MaterialApp para que todas las rutas la vean.
    return Dependencias(
      child: MaterialApp(
        title: LibreriaConfig.nombre,
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );
  }
}
