import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:libreria/domain/services/avisos.dart';
import 'package:libreria/domain/services/push.dart';

/// Une los avisos locales y el push: qué pantalla abrir al tocar uno, y cómo
/// mostrar un push que llega con la app abierta.
class CoordinadorAvisos {
  CoordinadorAvisos(this._avisos, this._push, {required this.abrir});

  final ServicioAvisos _avisos;
  final ServicioPush _push;
  final void Function(String destino) abrir;
  final _suscripciones = <StreamSubscription<Object?>>[];

  void iniciar() {
    _suscripciones.addAll([
      _avisos.toques.listen(abrir),
      _push.toques.listen(abrir),
      // Con la app abierta, Android no muestra el push: lo hacemos nosotros.
      _push.recibidos.listen(
        (aviso) => _avisos.mostrar(
          aviso.titulo,
          aviso.cuerpo,
          destino: aviso.destino,
          novedad: true,
        ),
      ),
    ]);
  }

  /// La app estaba cerrada y se abrió tocando un aviso.
  Future<void> abrirDesdeAviso() async {
    try {
      final destino =
          await _avisos.tocadoAlAbrir() ?? await _push.tocadoAlAbrir();
      if (destino != null) abrir(destino);
    } catch (e) {
      debugPrint('Aviso de apertura: $e');
    }
  }

  void dispose() {
    for (final suscripcion in _suscripciones) {
      suscripcion.cancel();
    }
  }
}
