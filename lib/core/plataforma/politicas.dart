import 'package:libreria/core/plataforma/capacidades.dart';

/// Qué DEBE hacer la app, con nombres del negocio.
class Politicas {
  const Politicas([this._capacidades = const Capacidades()]);

  final Capacidades _capacidades;

  /// En una computadora el botón "Sacar foto" fallaría.
  bool get ofrecerSacarFoto => _capacidades.tieneCamara;

  bool get ofrecerAvisoAutomatico => _capacidades.ejecutaTareasEnSegundoPlano;
}
