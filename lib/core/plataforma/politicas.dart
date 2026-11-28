import 'package:libreria/core/plataforma/capacidades.dart';

/// Qué DEBE hacer la app, con nombres del negocio.
class Politicas {
  const Politicas([this._capacidades = const Capacidades()]);

  final Capacidades _capacidades;

  /// En una computadora el botón "Sacar foto" fallaría.
  bool get ofrecerSacarFoto => _capacidades.tieneCamara;

  bool get ofrecerAvisoAutomatico => _capacidades.ejecutaTareasEnSegundoPlano;

  /// SQLite solo en la app del celular; la web usa la caché de Firestore.
  bool get usarBaseLocal => _capacidades.esAppDeCelular;

  /// Mantener al día la copia local con la app cerrada.
  bool get sincronizarEnSegundoPlano =>
      _capacidades.ejecutaTareasEnSegundoPlano;

  /// Falta configurar el push para web y iPhone.
  bool get recibirPush => _capacidades.ejecutaTareasEnSegundoPlano;
}
