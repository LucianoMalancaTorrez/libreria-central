# Especificación de requisitos: Librería Central Winterbach

Formato resumido tipo SRS (IEEE 830). Fuente: entrevistas con Amelia
Winterbach y devoluciones de la cátedra.

## 1. Introducción

**Propósito:** definir qué hace la app de la librería.
**Alcance:** informar y atraer clientes al local. No vende.
**Usuarios:** clientes del barrio (incluye personas que ven mal pantallas
chicas) y la administradora (Amelia o quien la ayude).
**Entorno:** navegador y Android. En iPhone, la web instalada.

## 2. Requisitos funcionales

| Nº | Requisito | Prioridad | Cómo se verifica |
|---|---|---|---|
| RF1 | Ver el catálogo con título, autor y tapa, sin precios | Alta | Abrir Catálogo |
| RF2 | Buscar por título, autor o género | Alta | Buscar "garcia" encuentra "García" |
| RF3 | Ver horarios, dirección, WhatsApp, mapa e Instagram | Alta | Más > Horarios y contacto |
| RF4 | Mostrar el beneficio de cada escuela para presentar en caja | Alta | Más > Convenios |
| RF5 | Conocer la historia de la familia | Media | Más > Nuestra historia |
| RF6 | Actualizar libros y horarios sin ayuda técnica | Alta | Panel de administración |
| RF7 | Guardar libros para preguntar por ellos | Baja | Mi lista |
| RF8 | Saber si el local está abierto | Media | Inicio |
| RF9 | Recibir aviso del club de lectura | Baja | Club de lectura > Avisos |

RF7 a RF9 los agregó el equipo; no los pidió la clienta.

## 3. Requisitos no funcionales

| Nº | Requisito | Cómo se verifica |
|---|---|---|
| RNF1 | Costo de funcionamiento cero | Solo planes gratuitos |
| RNF2 | Letra legible y ajustable, alto contraste | Más > Tamaño de letra |
| RNF3 | Usable en celular, tablet y computadora | Achicar la ventana |
| RNF4 | Abrir sin conexión después de la primera vez | Modo avión |
| RNF5 | Solo la administradora modifica los datos | `firestore.rules` |
| RNF6 | Pedir permisos solo al usar la función | Activar avisos |
| RNF7 | Flutter y Dart (exigido por la cátedra) | `pubspec.yaml` |

## 4. Falsos requerimientos y requisitos no realizables

| Pedido | Análisis | Resolución |
|---|---|---|
| "Quiero una app" | Publicar en tiendas cuesta dinero y mantenimiento | Web instalable (PWA), más APK |
| Cargar los 4.000 libros | No hay datos ni fotos, y no alcanza el tiempo | Empezar con unos 100 |
| Venta por internet | La clienta no la quiere | Fuera del alcance |
| Código QR para el descuento | Amelia no ve bien la pantalla | Pantalla grande y carnet del colegio |
| Descuento en manuales | El precio lo fija la editorial | Solo literatura, cuentos y novelas |

## 5. Pendientes de confirmar con la clienta

Número de WhatsApp, usuario de Instagram, horario de verano de la mañana, fecha
del cambio de temporada, horario del club, listado de libros y fotos.
