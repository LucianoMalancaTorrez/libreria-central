# Rúbrica del EGI: dónde está cada cosa

Rutas relativas a `lib/`. La columna "Falta" es lo que todavía no está
comprobado o depende de una persona.

| Criterio | Qué mostrar | Dónde | Falta |
|---|---|---|---|
| **A1** Alcance y respuesta al cliente | Sin ventas ni precios; web instalable en vez de app de tienda; panel para que Amelia actualice | `presentation/catalogo`, `presentation/admin` | Datos reales de Amelia |
| **B1** Widgets y composición | Pantallas armadas con widgets chicos y reutilizables | `core/widgets`, `presentation/*/widgets` | |
| **B2** Estado y ciclo de vida | `setState` local, `ChangeNotifier` compartido, `initState`, `didChangeDependencies`, `didUpdateWidget`, `dispose` | `inicio/widgets/indicador_apertura.dart`, `catalogo/widgets/info_externa_libro.dart`, `favoritos/viewmodels` | |
| **B3** Interacción y navegación | Barra inferior o lateral, `Navigator`, pestañas, toque, doble toque, mantener, deslizar, arrastrar | `principal/principal_screen.dart`, `catalogo/widgets/tarjeta_libro.dart`, `favoritos/` | |
| **B4** Multiplataforma y adaptativo | Web y Android, cortes 600/840, teclado, mouse, modo oscuro, capacidades y políticas | `core/plataforma/`, `core/widgets/tamano_ventana.dart` | Probar en iPhone (como web) |
| **C1** Arquitectura en capas | domain / data / presentation con MVVM y contratos | `domain/repositories`, `data/`, `app/dependencias.dart` | |
| **C2** Código limpio y herramientas | `flutter analyze` sin avisos, formato con `dart format` | `analysis_options.yaml` | Mostrar Flutter DevTools |
| **C3** Refactoring | De pantallas de más de 300 líneas a capas | commit "Reorganizar en capas" frente al commit inicial | |
| **C4** Pruebas | Unitarias, de interfaz y de integración | `test/`, `integration_test/` | Correr la de integración en el celular |
| **D1** Capacidades y políticas | Permiso de notificaciones al momento de usarlo, acceso a Ajustes, política de privacidad | `core/services/avisos.dart`, `ajustes/privacidad_screen.dart` | Probar en el celular |
| **D2** Future y async/await | Carga con estados cargando, error y éxito | `core/viewmodels/view_model.dart` | |
| **D3** Streams e Isolates | Catálogo y horarios en vivo; JSON procesado con `compute` | `data/repositories`, `core/services/conexion.dart` | En la web `compute` no usa otro hilo |
| **E1** Notificaciones | Local, a hora fija, push y apertura de pantalla al tocarlas | `core/services/avisos.dart`, `core/services/push.dart` | Probar en el celular |
| **E2** Segundo plano | Tarea única con restricción de red y periódica (solo Android) | `core/services/avisos.dart` | Probar en el celular |
| **E3** Eventos del sistema | Pérdida de conexión y regreso a la app | `core/widgets/aviso_sin_conexion.dart`, `indicador_apertura.dart` | |
| **F1** Persistencia, APIs y cámara | Preferencias, SQLite, Firestore, Open Library, foto de tapa | `data/`, `admin/viewmodels/foto_view_model.dart` | Crear la cuenta y probar la cámara |
| **F2** Dispositivo real y publicación | Web en Firebase Hosting y APK de release | `firebase.json` | **Probar en celulares y anotar resultados** |
| **G1** Demo y defensa | Guion de abajo | | Ensayar |

## Temas de los apuntes

| Apunte | Dónde verlo |
|---|---|
| Material widgets | Badge, SnackBar, AlertDialog, BottomSheet, Chip, SegmentedButton, Slider, Switch, Checkbox, Radio, MenuAnchor, DatePicker, TimePicker, TabBar, NavigationBar, NavigationRail, FAB |
| Listas y grillas | Lista horizontal (destacados), grilla adaptable, lista con encabezados por género, `ListView.builder` |
| Layout y scrolling | `Row`, `Column`, `Stack`, `Expanded`, `CustomScrollView` con slivers |
| Animaciones | `AnimatedContainer`, `AnimatedSwitcher`, `AnimatedSize`, `TweenAnimationBuilder` |
| ViewModel y ChangeNotifier | `ListenableBuilder` con los tres estados (`core/widgets/vista_estado.dart`) |
| pubspec.yaml | Dependencias, assets, versiones, ícono y splash |

**No se usan:** `BottomAppBar` (ya hay barra de navegación), efecto parallax
(el apunte lo marca como opcional), `GestureDetector` directo (los gestos se
capturan con `InkWell`, que lo usa por dentro) y BLoC (no está en el material).

## Probar en el celular (completar)

| Prueba | Android | iPhone |
|---|---|---|
| Instalar la app (25/11) | Anda bien | Anda bien |
| Abrir sin conexión (después de abrirla una vez) | | |
| Activar y probar el aviso del club | | no aplica |
| Aviso con la app cerrada un jueves | | no aplica |
| Guardar un libro, cerrar y volver a abrir | | |
| "Recordármelo" en un encuentro | | no aplica |
| Push enviado desde la consola | | no aplica |
| Tocar un aviso abre el club | | no aplica |
| Modo oscuro del sistema se lee bien | | |
| Ingresar al panel y sacar una foto | | |

## Guion para la demo (5 minutos)

1. El pedido: Amelia pidió "una app"; se resolvió con una web instalable, gratis.
2. Inicio: abierto o cerrado. Catálogo: buscar, filtrar, ordenar.
3. Guardar con doble toque, ordenar arrastrando, deslizar y deshacer.
4. Panel: cargar un libro con foto y ver cómo aparece en otro dispositivo.
5. Modo avión: aparece el aviso y la app sigue abriendo.
6. Código: capas, un ViewModel y una prueba.

## Preguntas probables

- **¿Por qué capas?** Para cambiar de dónde vienen los datos sin tocar las
  pantallas. Pasó al sumar Firebase.
- **¿`setState` o `ChangeNotifier`?** `setState` para lo que es de un solo
  widget (la pestaña elegida); `ChangeNotifier` para lo compartido (la lista).
- **¿Cómo actualiza Amelia el catálogo?** Desde el panel, con su cuenta.
- **¿Qué impide que otro modifique los datos?** Las reglas de Firestore: solo
  escribe quien figura en `admins`.
- **¿Qué pasa sin internet?** La web abre desde la copia guardada y el catálogo
  usa la copia local.
