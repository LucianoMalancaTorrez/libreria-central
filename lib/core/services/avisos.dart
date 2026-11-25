import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:libreria/domain/logic/club_lectura.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

enum ResultadoPermiso { concedido, denegado, bloqueado }

/// Notificaciones, permisos y tarea en segundo plano, detrás de una interfaz
/// para poder reemplazarla en los tests.
abstract class ServicioAvisos {
  bool get soportaSegundoPlano;
  Future<ResultadoPermiso> pedirPermiso();
  Future<void> mostrar(String titulo, String cuerpo);
  Future<void> programarRevision(bool activa);
  Future<void> abrirAjustes();
}

const _tareaClub = 'revisar-club-lectura';

class ServicioAvisosDispositivo implements ServicioAvisos {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _inicio;

  /// En iPhone haría falta configuración extra en Xcode (requiere una Mac).
  @override
  bool get soportaSegundoPlano =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> _iniciar() => _inicio ??= _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      web: WebInitializationSettings(),
    ),
  );

  @override
  Future<ResultadoPermiso> pedirPermiso() async {
    final estado = await Permission.notification.request();
    if (estado.isGranted) return ResultadoPermiso.concedido;
    if (estado.isPermanentlyDenied) return ResultadoPermiso.bloqueado;
    return ResultadoPermiso.denegado;
  }

  @override
  Future<void> mostrar(String titulo, String cuerpo) async {
    await _iniciar();
    await _plugin.show(
      id: 1,
      title: titulo,
      body: cuerpo,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'club_lectura',
          'Club de lectura',
          channelDescription: 'Avisos de los encuentros de los jueves',
        ),
      ),
    );
  }

  @override
  Future<void> programarRevision(bool activa) async {
    if (!soportaSegundoPlano) return;
    final gestor = Workmanager();
    await gestor.initialize(tareasEnSegundoPlano);
    if (activa) {
      // Android decide el momento exacto; revisa varias veces por día.
      await gestor.registerPeriodicTask(
        _tareaClub,
        _tareaClub,
        frequency: const Duration(hours: 6),
      );
    } else {
      await gestor.cancelByUniqueName(_tareaClub);
    }
  }

  @override
  Future<void> abrirAjustes() => openAppSettings();
}

/// Punto de entrada que Android ejecuta con la app cerrada, en otro Isolate.
@pragma('vm:entry-point')
void tareasEnSegundoPlano() {
  Workmanager().executeTask((tarea, datos) async {
    final hoy = DateTime.now();
    if (!esDiaDeClub(hoy)) return true;

    // Un solo aviso por jueves, aunque la tarea corra varias veces.
    final preferencias = await SharedPreferences.getInstance();
    final marca = '${hoy.year}-${hoy.month}-${hoy.day}';
    if (preferencias.getString('ultimo_aviso_club') == marca) return true;

    await ServicioAvisosDispositivo().mostrar(
      'Hoy hay club de lectura',
      'Te esperamos en Librería Central, Belgrano 742.',
    );
    await preferencias.setString('ultimo_aviso_club', marca);
    return true;
  });
}
