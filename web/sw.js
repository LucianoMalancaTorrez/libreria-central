// Service worker propio: Flutter dejó de generar uno con caché.
// Estrategia "primero la red": con internet siempre se ve la última versión;
// sin internet se usa la copia guardada.
'use strict';

const CACHE = 'libreria-v1';
// Además del propio sitio: tipografías y bibliotecas de Google.
// Las llamadas a la base de datos no se guardan acá (de eso se ocupa Firestore).
const EXTERNOS = ['https://fonts.gstatic.com', 'https://www.gstatic.com'];

const guardable = (url) => {
  const origen = new URL(url).origin;
  return origen === self.location.origin || EXTERNOS.includes(origen);
};

self.addEventListener('install', () => self.skipWaiting());

self.addEventListener('activate', (evento) => {
  evento.waitUntil(
    (async () => {
      for (const nombre of await caches.keys()) {
        if (nombre !== CACHE) await caches.delete(nombre);
      }
      await self.clients.claim();
    })(),
  );
});

// En la primera visita los archivos se bajan antes de que esto funcione:
// la página envía la lista para guardarlos igual.
self.addEventListener('message', (evento) => {
  if (!Array.isArray(evento.data)) return;
  evento.waitUntil(
    caches.open(CACHE).then((cache) =>
      Promise.allSettled(
        evento.data.filter(guardable).map((url) => cache.add(url)),
      ),
    ),
  );
});

self.addEventListener('fetch', (evento) => {
  const pedido = evento.request;
  if (pedido.method !== 'GET' || !guardable(pedido.url)) return;
  evento.respondWith(
    (async () => {
      const cache = await caches.open(CACHE);
      try {
        const respuesta = await fetch(pedido);
        if (respuesta.ok) cache.put(pedido, respuesta.clone());
        return respuesta;
      } catch (error) {
        const guardada = await cache.match(pedido, {
          ignoreSearch: pedido.mode === 'navigate',
        });
        if (guardada) return guardada;
        throw error;
      }
    })(),
  );
});
