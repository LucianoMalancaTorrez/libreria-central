import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:libreria/data/local/libros_dao.dart';
import 'package:libreria/data/repositories/firestore_libro_repository.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/firebase_options.dart';
import 'package:workmanager/workmanager.dart';

/// Por qué workmanager además de las notificaciones programadas: un aviso
/// programado solo muestra un texto fijo, no ejecuta código. Para bajar el
/// catálogo con la app cerrada hace falta una tarea en segundo plano.
const _tarea = 'sincronizar-catalogo';

Future<void> programarSincronizacion() async {
  try {
    final gestor = Workmanager();
    await gestor.initialize(sincronizarEnSegundoPlano);
    // Versiones anteriores usaban workmanager para avisar los jueves.
    await gestor.cancelByUniqueName('revisar-club-lectura');
    await gestor.cancelByUniqueName('revisar-club-lectura-inicial');
    await gestor.registerPeriodicTask(
      _tarea,
      _tarea,
      frequency: const Duration(hours: 12),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  } catch (e) {
    debugPrint('No se pudo programar la sincronización: $e');
  }
}

/// Reemplaza la copia local. Un catálogo vacío nunca la borra.
Future<void> guardarCopia(
  Future<List<Libro>> Function() descargar,
  LibrosDao dao,
) async {
  final libros = await descargar();
  if (libros.isNotEmpty) await dao.reemplazarTodos(libros);
}

/// Punto de entrada que Android ejecuta con la app cerrada, en otro Isolate:
/// no ve las variables de la app y tiene que iniciar Firebase de nuevo.
@pragma('vm:entry-point')
void sincronizarEnSegundoPlano() {
  Workmanager().executeTask((tarea, datos) async {
    try {
      DartPluginRegistrant.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final nube = FirestoreLibroRepository(FirebaseFirestore.instance);
      await guardarCopia(nube.descargar, LibrosDao.enDispositivo());
      debugPrint('Catálogo sincronizado en segundo plano');
      return true;
    } catch (e) {
      debugPrint('Sincronización en segundo plano: $e');
      // false: el sistema la reintenta más tarde.
      return false;
    }
  });
}
