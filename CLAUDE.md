# Librería Central

App informativa en Flutter (web instalable y Android) para la librería de
Amelia Winterbach. Proyecto EGI de Programación de Aplicaciones para Celulares.

## Reglas del negocio

- No agregar carrito, pagos, precios ni cuentas de clientes.
- Nada que no esté confirmado por Amelia se inventa: se marca `PENDIENTE`.
- Los datos que cambian van en `lib/core/config` o en repositorios.
- Interfaz para una persona mayor: letra grande, alto contraste, textos simples.

## Reglas técnicas

- Todo gratis. Preguntar antes de sumar una dependencia y revisar en pub.dev que
  soporte las plataformas que se usan.
- Capas: `presentation` → `domain` ← `data`. Las pantallas no importan `data`.
- ViewModels con `ChangeNotifier`, sin `BuildContext`.
- Colores con `context.colores`, nunca fijos: hay tema claro y oscuro.
- Interfaz y comentarios en español.
- No subir `key.properties`, claves de firma ni `build/`.

## Comandos

```powershell
flutter analyze
```

```powershell
flutter test
```

```powershell
flutter build web --release --no-web-resources-cdn
```

```powershell
flutter build apk --release
```

La PC tiene 6 GB: antes de compilar Android, cerrar programas pesados.
Publicar (`firebase deploy`) y hacer `git push` solo si se pide.

## Más contexto

`README.md`, `docs/REQUISITOS.md`, `docs/RUBRICA.md`, `docs/CURSO.md`.
