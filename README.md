# Librería Central — Sitio Web PWA

Sitio web informativo de **Librería Central**, construido con Flutter Web y configurado como PWA (Progressive Web App) instalable en Android e iOS.

## Contenido

- Catálogo de libros (título, autor, tapa)
- Historia del local
- Información de contacto (WhatsApp, Instagram, mapa, horarios)

## Requisitos previos

- [Flutter SDK](https://flutter.dev/install/windows) — descomprimido en `C:\flutter`
- `C:\flutter\bin` agregado al PATH del sistema
- Google Chrome instalado

## Levantar en modo desarrollo (con hot-reload)

```bat
cd C:\Users\USUARIO\Desktop\Libreria\Libreria
flutter pub get
flutter run -d chrome
```

## Generar build de producción (para deploy)

```bat
flutter build web --web-renderer canvaskit --release
```

El output queda en `build\web\`. Esa carpeta se sube completa al hosting (Netlify, Firebase, GitHub Pages).

## Deploy rápido sin dominio — Netlify

1. Ejecutar `flutter build web --release`
2. Ir a [netlify.com](https://netlify.com) → iniciar sesión
3. Arrastrar la carpeta `build\web\` al panel de Netlify
4. ¡Listo! Queda online con HTTPS en minutos

## Paleta de colores (identidad visual)

| Token | Hex | Uso |
|---|---|---|
| `parchment` | `#F5F2EB` | Fondo principal |
| `parchmentDeep` | `#EDE3CE` | Cards / fondo secundario |
| `leather` | `#5C4033` | Texto principal |
| `leatherDeep` | `#3B2A20` | Headers / énfasis |
| `bottleGreen` | `#0B6623` | Acento primario |
| `brass` | `#B08D57` | Bordes / acento secundario |
