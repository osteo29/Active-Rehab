const CACHE_NAME = 'activerehab-v7';
const APP_SHELL = ['/', '/manifest.json', '/favicon.png', '/icon-192.png', '/icon-512.png', '/apple-touch-icon.png'];

self.addEventListener('install', (event) => {
  event.waitUntil(caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL)).catch(() => undefined));
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(caches.keys().then((keys) => Promise.all(
    keys.filter((key) => key !== CACHE_NAME && /^(physiohub-|activerehab-)/.test(key))
      .map((key) => caches.delete(key)),
  )));
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  const request = event.request;
  const url = new URL(request.url);
  // Leave third-party requests and dynamic/private endpoints entirely to the network.
  if (url.origin !== self.location.origin || /^\/(api|auth|admin)(\/|$)/.test(url.pathname) ||
      /^\/(en|ar)\/(auth|admin|dashboard)(\/|$)/.test(url.pathname) || url.pathname === '/dashboard') return;

  const isNavigation = request.mode === 'navigate' || request.headers.get('accept')?.includes('text/html');
  const remember = (response) => {
    if (response.ok && !response.redirected && response.type !== 'opaque' &&
        !/no-store|private/i.test(response.headers.get('cache-control') || '')) {
      const copy = response.clone();
      event.waitUntil(caches.open(CACHE_NAME).then((cache) => cache.put(request, copy)).catch(() => undefined));
    }
    return response;
  };

  if (isNavigation) {
    event.respondWith(fetch(request).then(remember).catch(async () =>
      (await caches.match(request)) || (await caches.match('/')) ||
      new Response('Offline. Reconnect and try again.', {status: 503, headers: {'Content-Type': 'text/plain; charset=utf-8'}}),
    ));
    return;
  }

  // Only immutable build assets and static media use cache-first. An offline script,
  // image or JSON request must never receive the home page as its response.
  if (!/\.(?:js|css|png|jpe?g|webp|gif|svg|ico|woff2?|ttf|json|webmanifest)$/i.test(url.pathname)) return;
  event.respondWith(caches.match(request).then((cached) => cached ||
    fetch(request).then(remember).catch(() => Response.error()),
  ));
});
