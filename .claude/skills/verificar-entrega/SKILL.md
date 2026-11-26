---
name: verificar-entrega
description: Verifica que el proyecto de la Librería Central esté listo para entregar. Usar antes de un commit importante, de publicar o de la defensa.
---

# Verificar la entrega

Desde la raíz del proyecto, en este orden. Si un paso falla, parar e informar el
error tal como salió.

1. `dart format --output=none --set-exit-if-changed lib test integration_test`
2. `flutter analyze` (debe terminar sin avisos)
3. `flutter test` (deben pasar todas)
4. `flutter build web --release --no-web-resources-cdn`
5. Archivos delicados: `git ls-files` no debe incluir `key.properties`, `*.jks`,
   `*.keystore`, `local.properties` ni `build/`.
6. Capas: `lib/presentation` no importa `package:libreria/data/`; `lib/domain`
   solo importa `domain`; `lib/core` no importa `app`, `data` ni `presentation`.
7. Colores: fuera de `lib/core/theme` no aparece `AppColors.`.

Terminar con una tabla: paso, resultado y, si falló, el motivo. No publicar ni
subir nada.
