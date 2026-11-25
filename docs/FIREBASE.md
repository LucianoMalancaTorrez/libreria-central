# Firebase en Librería Central

Proyecto `libreria-central-53b7c`, plan gratuito (Spark, sin tarjeta).

## Qué hay en la nube

| Dato | Dónde | Quién escribe |
|---|---|---|
| Libros (con la foto de la tapa) | `libros/{id}` | Administradora |
| Horarios | `config/horarios` | Administradora |
| Quién es administradora | `admins/{uid}` | Solo desde la consola |

Cualquiera puede leer libros y horarios. Las reglas están en `firestore.rules`.

## Dar de alta la cuenta de la librería (una sola vez)

1. [Consola de Firebase](https://console.firebase.google.com/project/libreria-central-53b7c/authentication/users):
   **Authentication > Users > Add user**. Escribir correo y contraseña.
2. Copiar el **User UID** de esa cuenta.
3. **Firestore Database > Start collection**: colección `admins`, **Document ID**
   igual al UID. Puede llevar un campo `nombre`.
4. En la app: **Más > Administración**, ingresar y, en la pestaña Libros, tocar
   **Cargar catálogo de ejemplo**.

## Guía rápida para Amelia

- **Agregar un libro:** Más > Administración > Nuevo libro. Completar título,
  autor y género, sacar la foto de la tapa y tocar Guardar.
- **Corregir un libro:** tocarlo en la lista.
- **Borrar un libro:** tocar el tacho y confirmar.
- **Cambiar un horario:** pestaña Horarios, tocar la hora y Guardar horarios.

## Enviar un aviso push (Android)

1. En el celular, activar **Club de lectura > Avisos**.
2. En la consola: **Messaging > Nueva campaña > Notificaciones**.
3. Escribir título y texto; en destino elegir **Tema** y poner `club`.
4. Enviar. La primera vez el tema puede tardar en aparecer en la consola.

Cloud Messaging es gratuito.

## Volver a publicar las reglas

```powershell
firebase deploy --only firestore,auth
```
