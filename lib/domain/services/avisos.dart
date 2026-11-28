enum ResultadoPermiso { concedido, denegado, bloqueado }

/// Pantallas que se pueden abrir al tocar un aviso.
const destinoClub = 'club';
const destinoCatalogo = 'catalogo';
const destinoHorarios = 'horarios';

/// El dato que llega de afuera solo vale si es un destino conocido.
String? destinoValido(Object? dato) => switch (dato) {
  destinoClub => destinoClub,
  destinoCatalogo => destinoCatalogo,
  destinoHorarios => destinoHorarios,
  _ => null,
};

/// Notificaciones locales y sus permisos, detrás de una interfaz para poder
/// reemplazarla en los tests.
abstract class ServicioAvisos {
  bool get soportaSegundoPlano;

  /// Destinos de los avisos que la persona va tocando.
  Stream<String> get toques;

  /// Destino si la app se abrió desde un aviso; null si no.
  Future<String?> tocadoAlAbrir();
  Future<ResultadoPermiso> pedirPermiso();

  /// [destino] es la pantalla que abre el toque; [novedad] indica que el aviso
  /// llegó por push y va por ese canal.
  Future<void> mostrar(
    String titulo,
    String cuerpo, {
    String? destino = destinoClub,
    bool novedad = false,
  });

  /// Aviso a una hora fija, aunque la app esté cerrada.
  Future<void> programar(DateTime cuando, String titulo, String cuerpo);

  /// Activa o cancela el aviso que se repite todos los jueves.
  Future<void> programarSemanal(bool activa);
  Future<void> abrirAjustes();
}
