# Resultado de las revisiones (25/11)

## Hallazgos en la app

Salen de leer el código. **Corregidos: 1, 2, 3 y 8**, con pruebas automáticas para 1 y 2.
El resto queda pendiente. Nada de esto se reprodujo en un dispositivo.

| Nº | Gravedad | Hallazgo | Encontrado por |
|---|---|---|---|
| 1 ✔ | Alta | Si la nube falla o está vacía sin caché, el catálogo de ejemplo pisa la copia buena en SQLite | revisor-arquitectura, revisor-seguridad |
| 2 ✔ | Alta | "Mi lista" puede reordenar el libro equivocado si hay favoritos que ya no existen | revisor-arquitectura |
| 3 ✔ | Media | Apagar los avisos no cancela "Recordármelo" ni la tarea única | revisor-seguridad |
| 4 | Media | Guardar un libro sin conexión queda en "Guardando..." y puede duplicarse | revisor-arquitectura |
| 5 | Media | La foto puede notificar después de cerrar el formulario o aparecer en otro libro | revisor-arquitectura |
| 6 | Media | Push: falta apagar el inicio automático de FCM para cumplir la política de privacidad | revisor-seguridad |
| 7 | Media | Verificar en la consola que no se puedan registrar cuentas nuevas | revisor-seguridad |
| 8 ✔ | Baja | Error de texto en Privacidad: "siactivás" (comprobado) | revisor-seguridad |
| 9 | Baja | Las reglas no validan el formato de `config/horarios` | revisor-seguridad |
| 10 | Baja | Falta `allowBackup="false"`, cabeceras en el hosting y completar la política | revisor-seguridad |
| 11 | Baja | Las pantallas de administración no tienen ViewModel; hay dirección y escuelas escritas a mano; `core` importa `app` | revisor-arquitectura |

## `/code-review` (nivel bajo, cambios de la rama)

Un hallazgo: el validador del servidor MCP se caía con un libro incompleto.
**Corregido** y probado con un dato inválido.

## `/security-review` (cambios de la rama)

Sin vulnerabilidades en los archivos nuevos. El análisis se hizo en la sesión
principal, sin los sub-pasos con agentes que propone el comando.

## Verificación de entrega

| Paso | Resultado |
|---|---|
| Formato, `flutter analyze` | Sin avisos |
| `flutter test` | 45 pruebas pasan (49 tras las correcciones) |
| Compilación web | Correcta |
| Archivos delicados, capas, colores | Correcto |
