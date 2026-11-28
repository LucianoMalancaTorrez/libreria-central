import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:libreria/core/plataforma/politicas.dart';
import 'package:libreria/domain/logic/club_lectura.dart';
import 'package:libreria/domain/logic/recordatorio.dart';
import 'package:libreria/domain/services/avisos.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as datos_zonas;
import 'package:timezone/timezone.dart' as tz;

/// Un id fijo por tipo de aviso evita duplicados.
const _idAviso = 1;
const _idRecordatorio = 2;
const _idSemanal = 3;
const _idNovedad = 4;

/// El mismo id está en el AndroidManifest como canal por defecto del push.
const _canalNovedades = AndroidNotificationChannel(
  'novedades',
  'Novedades de la librería',
  description: 'Libros nuevos y avisos que envía la librería',
  importance: Importance.high,
);

const _detalles = NotificationDetails(
  android: AndroidNotificationDetails(
    'club_lectura',
    'Club de lectura',
    channelDescription: 'Avisos de los encuentros de los jueves',
  ),
);

final _detallesNovedad = NotificationDetails(
  android: AndroidNotificationDetails(
    _canalNovedades.id,
    _canalNovedades.name,
    channelDescription: _canalNovedades.description,
    importance: Importance.high,
    priority: Priority.high,
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

  Future<void> _iniciar() => _inicio ??= _preparar();

  Future<void> _preparar() async {
    await _plugin.initialize(
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
    // Android necesita que el canal exista antes de que llegue el push.
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_canalNovedades);
  }

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
  Future<void> mostrar(
    String titulo,
    String cuerpo, {
    String? destino = destinoClub,
    bool novedad = false,
  }) async {
    await _iniciar();
    await _plugin.show(
      id: novedad ? _idNovedad : _idAviso,
      title: titulo,
      body: cuerpo,
      notificationDetails: novedad ? _detallesNovedad : _detalles,
      payload: destino,
    );
  }

  @override
  Future<void> programar(DateTime cuando, String titulo, String cuerpo) async {
    await _iniciar();
    final zona = _zonaDeMendoza();
    await _plugin.zonedSchedule(
      id: _idRecordatorio,
      title: titulo,
      body: cuerpo,
      scheduledDate: _enZona(zona, cuando),
      notificationDetails: _detalles,
      // Aproximado: no requiere el permiso de alarmas exactas.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: destinoClub,
    );
  }

  @override
  Future<void> programarSemanal(bool activa) async {
    if (!soportaSegundoPlano) return;
    await _iniciar();
    if (!activa) {
      await _plugin.cancel(id: _idSemanal);
      await _plugin.cancel(id: _idRecordatorio);
      return;
    }
    final zona = _zonaDeMendoza();
    final proximo = proximoAvisoSemanal(tz.TZDateTime.now(zona));
    await _plugin.zonedSchedule(
      id: _idSemanal,
      title: 'Hoy hay club de lectura',
      body: 'Te esperamos a las $horaClubLectura en Belgrano 742.',
      scheduledDate: _enZona(zona, proximo),
      notificationDetails: _detalles,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Se repite cada semana, el mismo día y a la misma hora.
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: destinoClub,
    );
  }

  tz.Location _zonaDeMendoza() {
    datos_zonas.initializeTimeZones();
    return tz.getLocation('America/Argentina/Mendoza');
  }

  tz.TZDateTime _enZona(tz.Location zona, DateTime f) =>
      tz.TZDateTime(zona, f.year, f.month, f.day, f.hour, f.minute);

  @override
  Future<void> abrirAjustes() => openAppSettings();
}
