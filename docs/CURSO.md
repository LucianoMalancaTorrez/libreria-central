# Temas del aula y dónde están en el proyecto

Comparación con el material del aula (programa 2026 y apuntes), al 25/11.

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
| Segundo plano | Tarea periódica con `workmanager` |
| Eventos del sistema | Conexión, ocultar y volver a la app |
| SharedPreferences | Lista, tamaño de letra, avisos, última búsqueda |
| API REST, HTTP, JSON y autenticación | Open Library y Firebase Auth |
| Datos en la nube | Firestore con reglas |
| Cámara y galería | Foto de la tapa |
| Pruebas unitarias y de interfaz | `test/` |
| Requisitos y presupuesto | `docs/REQUISITOS.md`, `docs/presupuesto/` |

## Falta (se ve en clase y la app no lo usa)

| Tema | Qué habría que sumar | Requiere |
|---|---|---|
| Base de datos local (SQLite) | Guardar el catálogo en el celular con `sqflite` | Paquetes `sqflite`, `path` |
| Notificaciones push | Recibir avisos enviados desde la consola de Firebase | `firebase_messaging` |
| Aviso a una hora fija | `zonedSchedule` | `timezone` |
| Abrir una pantalla al tocar el aviso | Manejar el toque de la notificación | Solo código |
| Cámara en capas | Guardar el archivo, recuperar fotos perdidas, fuente de fotos reemplazable | `path_provider` |
| Pruebas de integración | Recorrido completo en un dispositivo | `integration_test` (SDK) |
| Tarea única con restricciones | `registerOneOffTask` | Solo código |
| Modo oscuro | Responder al cambio de tema del sistema | Solo código |
| Firma del APK | Clave propia | La crea el grupo |
| Publicación en Google Play | Cuenta de desarrollador | **Pago (registro de Google)** |

## No corresponde

- **Room y Retrofit** son bibliotecas de Android nativo. En Flutter su lugar lo
  ocupan `sqflite` y `http`.
- **BLoC** aparece solo como vista previa; el apunte dice que no hace falta
  instalarlo.
- **MVC y MVP**: hay que saber explicarlos; el proyecto usa MVVM.
