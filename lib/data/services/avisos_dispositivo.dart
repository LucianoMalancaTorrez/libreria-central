import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:libreria/core/plataforma/politicas.dart';
import 'package:libreria/domain/logic/club_lectura.dart';
import 'package:libreria/domain/services/avisos.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as datos_zonas;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

const _tareaClub = 'revisar-club-lectura';

/// Un id fijo por tipo de aviso evita duplicados.
const _idAviso = 1;
const _idRecordatorio = 2;

const _detalles = NotificationDetails(
  android: AndroidNotificationDetails(
    'club_lectura',
    'Club de lectura',
    channelDescription: 'Avisos de los encuentros de los jueves',
  ),
);

class ServicioAvisosDispositivo implements ServicioAvisos {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _toques = StreamController<String>.broadcast();
  Future<void>? _inicio;

  @override
  bool get soportaSegundoPlano => const Politicas().ofrecerAvisoAutomatico;

  @override
  Stream<String> get toques => _toques.stream;

  Future<void> _iniciar() => _inicio ??= _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      web: WebInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (respuesta) {
      final destino = respuesta.payload;
      if (destino != null) _toques.add(destino);
    },
  );

  @override
  Future<String?> tocadoAlAbrir() async {
    if (!soportaSegundoPlano) return null;
    await _iniciar();
    final detalle = await _plugin.getNotificationAppLaunchDetails();
    if (detalle?.didNotificationLaunchApp != true) return null;
    return detalle?.notificationResponse?.payload;
  }

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
      id: _idAviso,
      title: titulo,
      body: cuerpo,
      notificationDetails: _detalles,
      payload: destinoClub,
    );
  }

  @override
  Future<void> programar(DateTime cuando, String titulo, String cuerpo) async {
    await _iniciar();
    datos_zonas.initializeTimeZones();
    final zona = tz.getLocation('America/Argentina/Mendoza');
    await _plugin.zonedSchedule(
      id: _idRecordatorio,
      title: titulo,
      body: cuerpo,
      scheduledDate: tz.TZDateTime(
        zona,
        cuando.year,
        cuando.month,
        cuando.day,
        cuando.hour,
        cuando.minute,
      ),
      notificationDetails: _detalles,
      // Aproximado: no requiere el permiso de alarmas exactas.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: destinoClub,
    );
  }

  @override
  Future<void> programarRevision(bool activa) async {
    if (!soportaSegundoPlano) return;
    final gestor = Workmanager();
    await gestor.initialize(tareasEnSegundoPlano);
    if (!activa) {
      await gestor.cancelByUniqueName(_tareaClub);
      await gestor.cancelByUniqueName('$_tareaClub-inicial');
      await _iniciar();
      await _plugin.cancel(id: _idRecordatorio);
      return;
    }
    // Una revisión ahora, cuando haya red, y otras periódicas.
    await gestor.registerOneOffTask(
      '$_tareaClub-inicial',
      _tareaClub,
      constraints: Constraints(networkType: NetworkType.connected),
    );
    await gestor.registerPeriodicTask(
      _tareaClub,
      _tareaClub,
      frequency: const Duration(hours: 6),
    );
  }

  @override
  Future<void> abrirAjustes() => openAppSettings();
}

/// Punto de entrada que Android ejecuta con la app cerrada, en otro Isolate:
/// no ve las variables de la app, solo lo guardado en el dispositivo.
@pragma('vm:entry-point')
void tareasEnSegundoPlano() {
  Workmanager().executeTask((tarea, datos) async {
    try {
      DartPluginRegistrant.ensureInitialized();
      final hoy = DateTime.now();
      if (!esDiaDeClub(hoy)) return true;

      // Un solo aviso por jueves, aunque la tarea corra varias veces.
      final preferencias = await SharedPreferences.getInstance();
      await preferencias.reload();
      final marca = '${hoy.year}-${hoy.month}-${hoy.day}';
      if (preferencias.getString('ultimo_aviso_club') == marca) return true;

      await ServicioAvisosDispositivo().mostrar(
        'Hoy hay club de lectura',
        'Te esperamos en Librería Central, Belgrano 742.',
      );
      await preferencias.setString('ultimo_aviso_club', marca);
      return true;
    } catch (e) {
      debugPrint('Tarea en segundo plano: $e');
      // false: el sistema la reintenta más tarde.
      return false;
    }
  });
}
