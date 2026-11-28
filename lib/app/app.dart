import 'dart:async';

import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/theme/app_theme.dart';
import 'package:libreria/domain/services/avisos.dart';
import 'package:libreria/presentation/eventos/eventos_screen.dart';
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
  final _suscripciones = <StreamSubscription<Object?>>[];

  @override
  void initState() {
    super.initState();
    _suscripciones.addAll([
      _servicios.avisos.toques.listen(_abrir),
      _servicios.push.toques.listen(_abrir),
      // Con la app abierta, Android no muestra el push: lo hacemos nosotros.
      _servicios.push.recibidos.listen(
        (aviso) => _servicios.avisos.mostrar(aviso.titulo, aviso.cuerpo),
      ),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) => _abrirDesdeAviso());
  }

  Future<void> _abrirDesdeAviso() async {
    try {
      _abrir(
        await _servicios.avisos.tocadoAlAbrir() ??
            await _servicios.push.tocadoAlAbrir(),
      );
    } catch (e) {
      debugPrint('Aviso de apertura: $e');
    }
  }

  void _abrir(String? destino) {
    if (destino != destinoClub) return;
    _navegador.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => const EventosScreen()),
    );
  }

  @override
  void dispose() {
    for (final suscripcion in _suscripciones) {
      suscripcion.cancel();
    }
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
