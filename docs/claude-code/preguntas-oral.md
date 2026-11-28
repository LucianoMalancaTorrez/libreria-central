# Simulacro de oral

Preparado por un subagente con las instrucciones de `profesor-examen`; resumido.

1. **¿Cómo organizaron las capas?** `domain` (modelos y contratos), `data` (implementaciones), `presentation` (pantallas y ViewModels). MVVM. `lib/domain/repositories`
2. **¿Dónde se elige la implementación?** En `Servicios`, entregado por el `InheritedWidget` `Dependencias`. Sin Firebase usa datos incluidos. `lib/app/dependencias.dart`
3. **¿`setState` o `ChangeNotifier`?** Local de un widget contra estado compartido. `favoritos_view_model.dart`
4. **¿Qué ciclo de vida usan?** `initState`/`dispose` (timer), `didChangeDependencies`, `didUpdateWidget`, `AppLifecycleListener`. `indicador_apertura.dart`
5. **¿Cargando, error y éxito?** Clase `ViewModel` y `VistaEstado`. Con Firebase, si falla se muestra el ejemplo. `core/viewmodels`
6. **¿`Future`, `Stream`, Isolate?** Un resultado, varios resultados, y `compute` para el JSON de ejemplo (en la web no usa otro hilo). `asset_libro_repository.dart`
7. **¿Qué guardan en el dispositivo?** Preferencias y una copia SQLite sin fotos. El buscador filtra en memoria. `libros_dao.dart`
8. **¿Quién puede modificar datos?** Solo quien está en `admins`. El panel y la cámara no constan como probados. `firestore.rules`
9. **¿Aviso a hora fija?** `zonedSchedule`, jueves 10 h, modo inexacto. No consta probado en un celular. `avisos.dart`
10. **¿Push?** Android, tema `club`, enviado desde la consola. No consta probado. `push.dart`
11. **¿Segundo plano?** `workmanager` sincroniza la copia del catálogo cada 12 h, con red y en otro Isolate. El aviso de los jueves es una notificación programada semanal. `sincronizacion_catalogo.dart`
12. **¿Qué pruebas hay?** 45, con falsos inyectados. `test/`
13. **¿Prueba de integración?** Una, escrita; no consta ejecutada en un dispositivo. `integration_test/app_test.dart`
14. **¿Firma y Google Play?** Clave de pruebas; no publicado (la cuenta es paga). `docs/FIRMA.md`
15. **¿Publicación web y sin conexión?** Firebase Hosting y service worker propio, primero la red. `web/sw.js`
