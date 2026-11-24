/// Pantalla principal de "Librería Central Winterbach" («lo de Amelia»).
/// Presenta las secciones clave del negocio acordadas con Amelia:
/// Catálogo de consulta, Convenios con escuelas, Información y Nuestra historia.
/// Las actividades académicas de clase se conservan en un menú lateral discreto.
library;

import 'package:libreria/core/config/libreria_config.dart';
import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/core/widgets/responsive_center.dart';
import 'package:libreria/presentation/catalogo/catalogo_screen.dart';
import 'package:libreria/presentation/escuelas/escuelas_screen.dart';
import 'package:libreria/presentation/historia/historia_screen.dart';
import 'package:libreria/presentation/informacion/informacion_screen.dart';
import 'package:libreria/presentation/inicio/widgets/buscador_inicio.dart';
import 'package:libreria/presentation/inicio/widgets/menu_ejercicios_drawer.dart';
import 'package:libreria/presentation/inicio/widgets/tarjeta_accion.dart';

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
              style: AppTheme.stampLabel(color: AppColors.bottleGreenDark)
                  .copyWith(fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        centerTitle: true,
      ),
      endDrawer: MenuEjerciciosDrawer(),
      body: ResponsiveCenter(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              BuscadorInicio(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CatalogoScreen()),
                ),
              ),
              const SizedBox(height: 20),

              // Catálogo: libros disponibles para consulta presencial (sin precios)
              TarjetaAccion(
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
              TarjetaAccion(
                icono: Icons.school_outlined,
                titulo: 'Convenios con escuelas',
                subtitulo:
                    '${LibreriaConfig.descuentoEscolar}% en literatura para Colegio San José y Escuela Sarmiento',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EscuelasScreen()),
                ),
              ),
              const SizedBox(height: 16),

              // Información: horarios, teléfono, WhatsApp, mapa e Instagram
              TarjetaAccion(
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
              TarjetaAccion(
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
