import 'package:flutter/foundation.dart';

/// Base de los ViewModels: maneja los tres estados (cargando, error, éxito).
/// Es Dart puro: no conoce widgets ni BuildContext, así se puede testear solo.
abstract class ViewModel extends ChangeNotifier {
  bool _cargando = false;
  String? _error;
  bool _descartado = false;

  bool get cargando => _cargando;
  String? get error => _error;

  @protected
  Future<void> ejecutar(
    Future<void> Function() tarea, {
    required String mensajeError,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      await tarea();
    } catch (e) {
      debugPrint('$mensajeError $e');
      _error = mensajeError;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    // La pantalla puede cerrarse mientras todavía se está cargando.
    if (!_descartado) super.notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    super.dispose();
  }
}
