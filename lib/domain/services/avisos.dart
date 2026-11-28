enum ResultadoPermiso { concedido, denegado, bloqueado }

/// Pantalla que se abre al tocar un aviso del club.
const destinoClub = 'club';

/// Notificaciones, permisos y tarea en segundo plano, detrás de una interfaz
/// para poder reemplazarla en los tests.
abstract class ServicioAvisos {
  bool get soportaSegundoPlano;

  /// Destinos de los avisos que la persona va tocando.
  Stream<String> get toques;

  /// Destino si la app se abrió desde un aviso; null si no.
  Future<String?> tocadoAlAbrir();
  Future<ResultadoPermiso> pedirPermiso();
  Future<void> mostrar(String titulo, String cuerpo);

  /// Aviso a una hora fija, aunque la app esté cerrada.
  Future<void> programar(DateTime cuando, String titulo, String cuerpo);
  Future<void> programarRevision(bool activa);
  Future<void> abrirAjustes();
}
