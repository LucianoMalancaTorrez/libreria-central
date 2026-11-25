import 'package:flutter/foundation.dart';
import 'package:libreria/core/services/avisos.dart';
import 'package:libreria/domain/repositories/preferencias_repository.dart';

/// Preferencias de la persona: letra grande y avisos del club de lectura.
class AjustesViewModel extends ChangeNotifier {
  AjustesViewModel(this._preferencias, this._avisos);

  final PreferenciasRepository _preferencias;
  final ServicioAvisos _avisos;
  bool _letraGrande = false;
  bool _avisosClub = false;

  bool get letraGrande => _letraGrande;
  bool get avisosClub => _avisosClub;

  Future<void> cargar() async {
    _letraGrande = await _preferencias.leerBool('letra_grande');
    _avisosClub = await _preferencias.leerBool('avisos_club');
    notifyListeners();
  }

  Future<void> cambiarLetraGrande(bool valor) async {
    _letraGrande = valor;
    notifyListeners();
    await _preferencias.guardarBool('letra_grande', valor);
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
    return ResultadoPermiso.concedido;
  }
}
