# Devolución de la cátedra (28/11/2026) y qué se hizo

| Observación | Qué se hizo |
|---|---|
| `core/services` mezclaba interfaz e implementación y dependía de `domain` | Contratos en `domain/services`, implementaciones en `data/services`. `core` ya no importa `domain` (también se movió `TapaLibro` a `presentation/comun`) |
| Una vista llamaba a un servicio | `ClubViewModel` para las dos pestañas del club |
| Aviso semanal programado | `zonedSchedule` con `matchDateTimeComponents`, jueves 10:00 |
| Justificar `workmanager` | Ya no avisa: sincroniza el catálogo (ver abajo) |
| Refrescar al volver a la app | `onResume` en catálogo, información e indicador de apertura |
| Push con destino | Dato `destino`: `club`, `catalogo` u `horarios` |
| Canal por defecto de push | `novedades` ("Novedades de la librería") en `AndroidManifest.xml` |
| Contar qué se pierde en la web | Pantalla de avisos en web y tabla de abajo |

## Por qué sigue workmanager

Una notificación programada muestra un texto fijo y **no ejecuta código**. Para
bajar el catálogo con la app cerrada y que la copia SQLite esté al día cuando
no haya internet, hace falta una tarea en segundo plano. Corre cada 12 horas,
solo con red, en otro Isolate (`data/services/sincronizacion_catalogo.dart`).
Android decide el momento exacto.

## Push: quién lo envía

Hoy lo envía una persona desde la **consola de Firebase** (Messaging). No hay
servidor propio: enviarlo solo, por ejemplo al cargar un libro, necesitaría
Cloud Functions, que exige el plan de pago de Firebase.

1. Messaging → crear campaña de notificaciones.
2. Título y texto.
3. Segmentación: tema `club`.
4. Opciones adicionales → datos personalizados: clave `destino`, valor
   `catalogo`.
5. Publicar.

| Estado de la app | Qué pasa |
|---|---|
| Cerrada o en segundo plano | Android muestra el push; al tocarlo abre `destino` |
| Abierta | La app lo muestra como notificación local; al tocarlo abre `destino` |

## Demo en el celular Android

1. Club de lectura → Avisos → activar → "Probar un aviso ahora".
2. Cerrar la app, enviar el push con `destino = catalogo`, tocarlo.
3. Con la app abierta, enviar otro y tocar la notificación local.
4. Aviso semanal: adelantar el reloj del celular a un jueves 9:58.

## Qué se pierde en la web y por qué

| Función | En la web | Motivo |
|---|---|---|
| Aviso semanal | No | La página no puede dejar un aviso programado para cuando está cerrada |
| Push | No | No está configurado (necesita su propio service worker y clave) |
| Segundo plano | No | `workmanager` es de Android |
| Base SQLite | No | Se usa la caché de Firestore y el service worker |
| Cámara | Según el navegador | `image_picker` abre el selector del teléfono |

En iPhone se usa la web: se instala con Safari → Compartir → Agregar a inicio.

## Refactoring: olores y antes/después

| Olor | Antes | Refactor | Después |
|---|---|---|---|
| Clase o método largo | `credencial_escuela_screen.dart`: 325 líneas | Extraer widgets | 48 líneas y widgets aparte |
| Responsabilidades mezcladas | `catalogo_screen.dart`: 166 líneas, pedía datos y filtraba con `setState` | Extraer ViewModel | 77 líneas y `CatalogoViewModel` |
| Dependencia global | La pantalla usaba `AppRepositories.libroRepository` | Inyección de dependencias | `Dependencias.of(context)` |
| Capa que depende de lo que no debe | `core` importaba plugins y `domain` | Mover contrato e implementación | `domain/services` y `data/services` |
| Vista que habla con un servicio | `pestana_avisos` llamaba a `avisos.mostrar` | Extraer ViewModel | `ClubViewModel` |

Commits para mostrar:

- `git show 3518d0f --stat`: de la versión inicial a capas.
- `git show f1d6bf8 --stat`: refactor puro, sin cambiar el comportamiento.

Los commits anteriores mezclan funciones y refactor; el historial no se
reescribe. Desde `f1d6bf8` van separados.

## Pendiente

- Probar en un celular: push con destino, aviso semanal, sincronización.
- Confirmar con Amelia: WhatsApp publicable, usuario de Instagram, sábados de
  verano.
- Quedan vistas que escuchan un repositorio sin ViewModel:
  `indicador_apertura.dart` y `favoritos_screen.dart`.
