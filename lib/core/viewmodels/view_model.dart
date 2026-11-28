import 'dart:async';

import 'package:flutter/foundation.dart';

/// Base de los ViewModels: maneja los tres estados (cargando, error, éxito).
/// Es Dart puro: no conoce widgets ni BuildContext, así se puede testear solo.
abstract class ViewModel extends ChangeNotifier {
  bool _cargando = false;
  String? _error;
  bool _descartado = false;
  StreamSubscription<void>? _suscripcion;
  Completer<void>? _primerDato;

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

  /// Se suscribe a un Stream: queda "cargando" hasta el primer dato y después
  /// avisa en cada cambio. La suscripción se cancela en [dispose].
  ///
  /// Con [silencioso] vuelve a pedir los datos sin mostrar "cargando" y, si
  /// falla, deja en pantalla lo que ya había.
  @protected
  Future<void> escuchar<T>(
    Stream<T> datos,
    void Function(T) alRecibir, {
    required String mensajeError,
    bool silencioso = false,
  }) {
    final primero = _primerDato = Completer<void>();
    void terminar() {
      _cargando = false;
      notifyListeners();
      if (!primero.isCompleted) primero.complete();
    }

    _suscripcion?.cancel();
    if (!silencioso) {
      _cargando = true;
      _error = null;
      notifyListeners();
    }
    _suscripcion = datos.listen(
      (dato) {
        alRecibir(dato);
        _error = null;
        terminar();
      },
      onError: (Object e) {
        debugPrint('$mensajeError $e');
        if (!silencioso) _error = mensajeError;
        terminar();
      },
    );
    return primero.future;
  }

  @override
  void notifyListeners() {
    // La pantalla puede cerrarse mientras todavía se está cargando.
    if (!_descartado) super.notifyListeners();
  }

  @override
  void dispose() {
    _descartado = true;
    _suscripcion?.cancel();
    // Nadie debe quedar esperando un dato que ya no va a llegar.
    final primero = _primerDato;
    if (primero != null && !primero.isCompleted) primero.complete();
    super.dispose();
  }
}
