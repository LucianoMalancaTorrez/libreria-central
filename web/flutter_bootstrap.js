{{flutter_js}}
{{flutter_build_config}}

// Sin serviceWorkerSettings: se usa el service worker propio (sw.js).
_flutter.loader.load();

if ('serviceWorker' in navigator) {
  window.addEventListener('load', async () => {
    await navigator.serviceWorker.register('sw.js');
    const registro = await navigator.serviceWorker.ready;
    // Espera a que la app termine de bajar sus archivos y tipografías.
    setTimeout(() => {
      const usados = performance.getEntriesByType('resource').map((r) => r.name);
      registro.active.postMessage([location.href, ...usados]);
    }, 8000);
  });
}
