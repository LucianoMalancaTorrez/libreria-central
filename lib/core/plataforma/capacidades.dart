import 'package:flutter/foundation.dart';

/// Qué PUEDE hacer el dispositivo. No decide qué conviene mostrar.
class Capacidades {
  const Capacidades();

  bool get esCelular =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Vale también para el navegador de un celular.
  bool get tieneCamara => esCelular;

  /// En iPhone haría falta configurar Xcode (requiere una Mac).
  bool get ejecutaTareasEnSegundoPlano =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
}
