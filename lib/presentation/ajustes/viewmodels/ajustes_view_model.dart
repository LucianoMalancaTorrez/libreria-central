import 'package:flutter/foundation.dart';
import 'package:libreria/core/services/avisos.dart';
import 'package:libreria/core/services/push.dart';
import 'package:libreria/domain/repositories/preferencias_repository.dart';

/// Preferencias de la persona: tamaño de letra y avisos del club de lectura.
class AjustesViewModel extends ChangeNotifier {
  AjustesViewModel(
    this._preferencias,
    this._avisos, [
    this._push = const SinPush(),
  ]);

  static const _escalas = [1.0, 1.2, 1.4];

  final PreferenciasRepository _preferencias;
  final ServicioAvisos _avisos;
  final ServicioPush _push;
  int _tamanoLetra = 0;
  bool _avisosClub = false;

  /// 0 normal, 1 grande, 2 muy grande.
  int get tamanoLetra => _tamanoLetra;
  double get escalaLetra => _escalas[_tamanoLetra];
  bool get avisosClub => _avisosClub;

  Future<void> cargar() async {
    // Se guarda como dos marcas para reutilizar el repositorio de booleanos.
    final grande = await _preferencias.leerBool('letra_grande');
    final muyGrande = await _preferencias.leerBool('letra_muy_grande');
    _tamanoLetra = muyGrande
        ? 2
        : grande
        ? 1
        : 0;
    _avisosClub = await _preferencias.leerBool('avisos_club');
    notifyListeners();
  }

  Future<void> cambiarTamanoLetra(int tamano) async {
    if (tamano == _tamanoLetra) return;
    _tamanoLetra = tamano;
    notifyListeners();
    await _preferencias.guardarBool('letra_grande', tamano == 1);
    await _preferencias.guardarBool('letra_muy_grande', tamano == 2);
  }

  /// Pide el permiso solo cuando la persona activa los avisos.
  Future<ResultadoPermiso> cambiarAvisosClub(bool activar) async {
    if (activar) {
      final permiso = await _avisos.pedirPermiso();
      if (permiso != ResultadoPermiso.concedido) return permiso;
    }
    await _avisos.programarRevision(activar);
    _avisosClub = activar;
    notifyListeners();
    await _preferencias.guardarBool('avisos_club', activar);
    try {
      await _push.suscribir(activar);
    } catch (e) {
      // Sin red el push falla, pero el aviso local sigue funcionando.
      debugPrint('Suscripción push: $e');
    }
    return ResultadoPermiso.concedido;
  }
}
