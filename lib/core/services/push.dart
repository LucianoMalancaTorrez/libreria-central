import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:libreria/core/services/avisos.dart';
import 'package:libreria/firebase_options.dart';

/// Un mensaje que llegó con la app abierta.
typedef AvisoPush = ({String titulo, String cuerpo});

/// Notificaciones enviadas desde la consola de Firebase.
abstract class ServicioPush {
  Future<void> suscribir(bool activo);
  Stream<AvisoPush> get recibidos;
  Stream<String> get toques;
  Future<String?> tocadoAlAbrir();
}

/// Web, iPhone y tests: no hay push.
class SinPush implements ServicioPush {
  const SinPush();

  @override
  Future<void> suscribir(bool activo) async {}
  @override
  Stream<AvisoPush> get recibidos => const Stream.empty();
  @override
  Stream<String> get toques => const Stream.empty();
  @override
  Future<String?> tocadoAlAbrir() async => null;
}

/// Android. Todos los suscriptos al tema `club` reciben el mismo aviso.
class PushFirebase implements ServicioPush {
  FirebaseMessaging get _mensajes => FirebaseMessaging.instance;

  @override
  Future<void> suscribir(bool activo) => activo
      ? _mensajes.subscribeToTopic('club')
      : _mensajes.unsubscribeFromTopic('club');

  @override
  Stream<AvisoPush> get recibidos => FirebaseMessaging.onMessage
      .where((m) => m.notification != null)
      .map(
        (m) => (
          titulo: m.notification!.title ?? 'Librería Central',
          cuerpo: m.notification!.body ?? '',
        ),
      );

  @override
  Stream<String> get toques =>
      FirebaseMessaging.onMessageOpenedApp.map((_) => destinoClub);

  @override
  Future<String?> tocadoAlAbrir() async =>
      await _mensajes.getInitialMessage() == null ? null : destinoClub;
}

/// Con la app cerrada, Android muestra la notificación solo; esta función
/// queda registrada para los mensajes que traigan datos.
@pragma('vm:entry-point')
Future<void> alRecibirEnSegundoPlano(RemoteMessage mensaje) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
