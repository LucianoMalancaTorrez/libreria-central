import 'package:flutter/foundation.dart';
import 'package:libreria/domain/logic/recordatorio.dart';
import 'package:libreria/domain/services/avisos.dart';

enum ResultadoRecordatorio {
  programado,
  yaSemanal,
  muyPronto,
  sinPermiso,
  fallo,
}

/// Lo que hacen las dos pestañas del club con los avisos. Las vistas solo
/// muestran el resultado. No guarda estado: el interruptor vive en los ajustes.
class ClubViewModel {
  ClubViewModel(this._avisos, {this.reloj = DateTime.now});

  final ServicioAvisos _avisos;
  final DateTime Function() reloj;

  bool get puedeAvisar => _avisos.soportaSegundoPlano;

  Future<void> abrirAjustes() => _avisos.abrirAjustes();

  /// false si no se pudo mostrar.
  Future<bool> probarAviso() async {
    try {
      await _avisos.mostrar(
        'Club de lectura',
        'Así te vamos a avisar los jueves.',
      );
      return true;
    } catch (e) {
      debugPrint('Aviso de prueba: $e');
      return false;
    }
  }

  /// Programa el aviso de un encuentro puntual. Con el aviso semanal activado
  /// no hace falta: saldría dos veces.
  Future<ResultadoRecordatorio> recordar(
    DateTime encuentro, {
    bool yaSemanal = false,
  }) async {
    if (yaSemanal) return ResultadoRecordatorio.yaSemanal;
    final hora = horaDelRecordatorio(encuentro, reloj());
    if (hora == null) return ResultadoRecordatorio.muyPronto;
    try {
      if (await _avisos.pedirPermiso() != ResultadoPermiso.concedido) {
        return ResultadoRecordatorio.sinPermiso;
      }
      await _avisos.programar(
        hora,
        'Hoy hay club de lectura',
        'Te esperamos en Librería Central.',
      );
      return ResultadoRecordatorio.programado;
    } catch (e) {
      debugPrint('Recordatorio: $e');
      return ResultadoRecordatorio.fallo;
    }
  }
}
