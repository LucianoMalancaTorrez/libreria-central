# Temas del aula y dónde están en el proyecto

Comparación con el material del aula (programa 2026 y apuntes), al 25/11 (actualizado).

## Integrado

| Tema | En el proyecto |
|---|---|
| Interfaces, widgets, navegación con parámetros | `presentation/`, detalle de libro y credencial |
| Dependencias y archivos de configuración | `pubspec.yaml`, manifest, Gradle, Info.plist |
| Arquitectura en capas y MVVM | `domain/`, `data/`, `presentation/` |
| Código limpio | Reglas de `limpio_ejemplos` en `analysis_options.yaml`, sin avisos |
| Refactoring | Historial de commits y pruebas |
| Diseño adaptativo y buenas prácticas | Cortes 600/840, `SafeArea`, teclado (Ctrl+1 a 4), mouse, sin bloquear orientación, `PageStorageKey` |
| Capacidades y políticas | `core/plataforma/`, probadas simulando plataformas |
| Future y async/await | Tres estados en los ViewModels, tiempos límite |
| Streams e Isolates | Catálogo y horarios en vivo, `compute` |
| Notificaciones locales y permisos | Club de lectura |
| Segundo plano | Tareas con `workmanager` |
| Eventos del sistema | Conexión, ocultar y volver a la app |
| SharedPreferences | Lista, tamaño de letra, avisos, última búsqueda |
| API REST, HTTP, JSON y autenticación | Open Library y Firebase Auth |
| Datos en la nube | Firestore con reglas |
| Cámara y galería | Foto de la tapa |
| Pruebas unitarias y de interfaz | `test/` (incluye ciclo de vida, plataformas y SQLite) |
| Requisitos y presupuesto | `docs/REQUISITOS.md`, `docs/presupuesto/` |
| Base de datos local (SQLite) | Copia del catálogo en el celular, consultas con parámetros: `data/local/libros_dao.dart` |
| Cámara en capas | `domain/services/fotos.dart`, borrador en archivo, fotos perdidas: `presentation/admin/viewmodels/foto_view_model.dart` |
| Avisos a una hora fija | `zonedSchedule` en Club de lectura (Android) |
| Tocar un aviso | Abre el Club de lectura: `app/app.dart` |
| Notificaciones push | `core/services/push.dart`, tema `club` (Android) |
| Tarea única con restricciones | `registerOneOffTask` cuando hay red |
| Modo oscuro | Sigue al sistema: `core/theme/app_theme.dart` |
| Pruebas de integración | `integration_test/app_test.dart` (corre en un dispositivo) |

## Falta o depende del grupo

| Tema | Situación |
|---|---|
| Firma del APK | El proyecto ya la lee de `android/key.properties`; la clave la crea el grupo (`docs/FIRMA.md`) |
| Publicación en Google Play | **Es paga** (registro de desarrollador); no se hizo |
| Probar en un dispositivo | Push, avisos programados, cámara y la prueba de integración |

## No corresponde

- **Room y Retrofit** son bibliotecas de Android nativo. En Flutter su lugar lo
  ocupan `sqflite` y `http`.
- **BLoC** aparece solo como vista previa; el apunte dice que no hace falta
  instalarlo.
- **MVC y MVP**: hay que saber explicarlos; el proyecto usa MVVM.
