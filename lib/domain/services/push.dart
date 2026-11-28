/// Un mensaje que llegó con la app abierta.
typedef AvisoPush = ({String titulo, String cuerpo});

/// Notificaciones enviadas desde la consola de Firebase.
abstract class ServicioPush {
  Future<void> suscribir(bool activo);
  Stream<AvisoPush> get recibidos;
  Stream<String> get toques;
  Future<String?> tocadoAlAbrir();
}
