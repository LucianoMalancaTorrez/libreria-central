# Librería Central Winterbach

App informativa de la librería de Amelia (Belgrano 742, Mendoza), hecha en
Flutter. Proyecto Integrador de Programación de Aplicaciones para Celulares.
No vende ni cobra: muestra el catálogo y ayuda a que la gente vaya al local.

**Web publicada:** https://libreria-central-53b7c.web.app

## Qué hace

- Catálogo con búsqueda, filtros por género, orden y detalle de cada libro.
- "Mi lista" para guardar libros y consultarlos por WhatsApp.
- Indicador de abierto o cerrado, horarios, dirección y contacto.
- Convenios con escuelas e historia de la familia.
- Club de lectura con avisos.
- Panel de administración para libros (con foto de la tapa) y horarios.
- Funciona como app instalable (PWA) y como APK de Android.

## Cómo está organizado

```
lib/
  app/           arranque e inyección de dependencias
  core/          configuración, tema, widgets y servicios comunes
  domain/        modelos, reglas de negocio y contratos (Dart puro)
  data/          implementaciones: assets, Firestore, preferencias, API
  presentation/  una carpeta por sección: pantallas, widgets y ViewModels
```

Las pantallas usan ViewModels (`ChangeNotifier`) y solo conocen los contratos de
`domain/`. Dónde vienen los datos se decide en `app/`, y los tests pasan
versiones falsas.

## Cómo correrlo

En Android Studio, abrir esta carpeta y tocar Run. Desde la terminal:

```powershell
flutter pub get
```

```powershell
flutter run -d chrome
```

Para un celular Android: activar la depuración por USB, conectarlo y ejecutar
`flutter run`.

## Pruebas y análisis

```powershell
flutter analyze
```

```powershell
flutter test
```

## Compilar y publicar

APK (queda en `build\app\outputs\flutter-apk\app-release.apk`):

```powershell
flutter build apk --release
```

Web. La opción `--no-web-resources-cdn` es necesaria para que abra sin conexión:

```powershell
flutter build web --release --no-web-resources-cdn
```

```powershell
firebase deploy --only hosting
```

## Costos

Todo usa planes gratuitos: Firebase Spark (Hosting, Firestore y Authentication,
sin tarjeta), Open Library y los paquetes de pub.dev. No se publica en Google
Play ni en App Store porque cobran. Las fotos de tapa se guardan comprimidas en
Firestore porque Firebase Storage requiere un plan con tarjeta.

## Pendientes y datos de ejemplo

- El catálogo es de ejemplo; no es el inventario real de Amelia.
- El número de WhatsApp es de relleno (`lib/core/config/libreria_config.dart`).
- Falta confirmar: usuario de Instagram, horario de verano de la mañana, fecha
  del cambio de temporada y horario del club de lectura.
- Faltan las fotos del local.
- El APK está firmado con la clave de pruebas.
- Las versiones de `flutter_local_notifications` y `permission_handler` están
  fijadas porque las más nuevas piden Android SDK 37.

## Más documentación

- [Rúbrica: dónde está cada tema](docs/RUBRICA.md)
- [Presupuesto para Amelia (borrador)](docs/presupuesto/Presupuesto-Libreria-Central.pdf)
- [Firebase y guía para Amelia](docs/FIREBASE.md)
