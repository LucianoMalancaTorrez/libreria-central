import 'package:flutter/material.dart';
import 'package:libreria/app/coordinador_avisos.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/services/avisos.dart';
import 'package:libreria/presentation/catalogo/catalogo_screen.dart';
import 'package:libreria/presentation/eventos/eventos_screen.dart';
import 'package:libreria/presentation/informacion/informacion_screen.dart';
import 'package:libreria/presentation/principal/principal_screen.dart';

class LibreriaApp extends StatefulWidget {
  const LibreriaApp({super.key, this.servicios});

  /// Solo los tests pasan servicios propios.
  final Servicios? servicios;

  @override
  State<LibreriaApp> createState() => _LibreriaAppState();
}

class _LibreriaAppState extends State<LibreriaApp> {
  late final Servicios _servicios = widget.servicios ?? Servicios();
  final _navegador = GlobalKey<NavigatorState>();
  late final CoordinadorAvisos _coordinador = CoordinadorAvisos(
    _servicios.avisos,
    _servicios.push,
    abrir: _abrir,
  );

  @override
  void initState() {
    super.initState();
    _coordinador.iniciar();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _coordinador.abrirDesdeAviso(),
    );
  }

  void _abrir(String destino) {
    final Widget? pantalla = switch (destino) {
      destinoClub => const EventosScreen(),
      destinoCatalogo => const CatalogoScreen(),
      destinoHorarios => const InformacionScreen(),
      _ => null,
    };
    if (pantalla == null) return;
    _navegador.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => pantalla),
    );
  }

  @override
  void dispose() {
    _coordinador.dispose();
    _servicios.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dependencias va por encima de MaterialApp para que todas las rutas la vean.
    return Dependencias(
      servicios: _servicios,
      child: MaterialApp(
        title: LibreriaConfig.nombre,
        navigatorKey: _navegador,
        // El tema claro u oscuro sigue al del sistema.
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        builder: (context, child) => ListenableBuilder(
          listenable: _servicios.ajustes,
          builder: (context, _) {
            final media = MediaQuery.of(context);
            // La letra elegida se suma a la que ya pida el sistema.
            final escala =
                media.textScaler.scale(1) * _servicios.ajustes.escalaLetra;
            return MediaQuery(
              data: media.copyWith(textScaler: TextScaler.linear(escala)),
              child: child!,
            );
          },
        ),
        home: const PrincipalScreen(),
      ),
    );
  }
}
