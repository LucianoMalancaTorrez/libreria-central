import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:libreria/domain/services/fotos.dart';

/// Foto de la tapa mientras se edita un libro.
class FotoViewModel extends ChangeNotifier {
  FotoViewModel(
    this._fuente,
    this._borrador, {
    required this.clave,
    String inicial = '',
  }) : _foto = inicial;

  /// Mismo límite que las reglas de la base de datos.
  static const maximoBytes = 500000;

  final FuenteFotos _fuente;
  final BorradorFoto _borrador;
  final String clave;
  String _foto;
  String? _error;

  /// En base64; vacío si no hay foto.
  String get foto => _foto;
  String? get error => _error;

  Future<void> recuperar() async {
    try {
      final bytes =
          await _fuente.recuperarPerdida() ?? await _borrador.leer(clave);
      if (bytes != null) _usar(bytes);
    } catch (e) {
      debugPrint('No se pudo recuperar la foto: $e');
    }
  }

  Future<void> elegir(OrigenFoto origen) async {
    _error = null;
    try {
      final bytes = await _fuente.elegir(origen);
      // Cancelar no es un error: se conserva la foto anterior.
      if (bytes == null) return;
      if (bytes.length > maximoBytes) {
        _error = 'La imagen es demasiado grande.';
        notifyListeners();
        return;
      }
      _usar(bytes);
      await _borrador.guardar(clave, bytes);
    } catch (e) {
      debugPrint('Foto: $e');
      _error = 'No se pudo abrir la cámara o galería.';
      notifyListeners();
    }
  }

  /// Se llama cuando el libro ya quedó guardado.
  Future<void> descartarBorrador() => _borrador.borrar(clave);

  void _usar(Uint8List bytes) {
    _foto = base64Encode(bytes);
    notifyListeners();
  }
}
