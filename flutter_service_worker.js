'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "759771715dce9289b1f112d6e6ac883e",
"index.html": "92619622aad7223b20e0ecf9adbea7f6",
"/": "92619622aad7223b20e0ecf9adbea7f6",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061",
"canvaskit/skwasm.js": "9fa2ffe90a40d062dd2343c7b84caf01",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"assets/AssetManifest.json": "1fc64556cf076a92d77fba697dfd0792",
"assets/AssetManifest.bin.json": "3d1ccd504f44aaaf55834277db7feb06",
"assets/NOTICES": "fc483eb4b0587abe03fe4f7fa1a1e0ba",
"assets/fonts/MaterialIcons-Regular.otf": "f6595ed090e4773baea9b40a474165a5",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin": "685c932d8f2b6045c87989b27591aca3",
"assets/assets/images/icons/maskot.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/icons/icon_app.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/kuda.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/katak.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/sapi.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/gajah.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/lebah.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/anjing.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/kelinci.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/bebek.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/kambing.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/kucing.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/ayam.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/burung.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/monyet.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/semut.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/kupukupu.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/kurakura.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/harimau.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/ikan.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/kepiting.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/images/hewan/ulat.png": "91e42db1c66c0b276abf6234dc50b2eb",
"assets/assets/audio/hewan/sapi.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/katak.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/ayam.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/ulat.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/monyet.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/lebah.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/semut.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/kambing.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/ikan.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/anjing.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/burung.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/kurakura.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/kelinci.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/bebek.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/kupukupu.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/kuda.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/kepiting.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/gajah.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/harimau.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/hewan/kucing.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/v.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/w.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/g.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/i.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/j.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/q.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/k.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/d.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/t.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/c.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/o.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/u.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/s.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/b.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/x.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/z.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/f.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/l.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/n.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/p.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/r.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/y.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/e.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/m.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/h.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/huruf/a.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/putih.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/biru.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/hitam.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/abuabu.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/coklat.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/merah.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/ungu.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/oranye.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/emas.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/kuning.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/pink.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/warna/hijau.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/sfx/yay.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/sfx/benar.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/sfx/salah.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/sfx/klik.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/6.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/2.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/1.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/7.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/3.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/9.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/5.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/10.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/8.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/audio/angka/4.mp3": "d41d8cd98f00b204e9800998ecf8427e",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"main.dart.js": "b540a9ee1c3a3d993e8e7ccbcd9dab76",
"flutter_bootstrap.js": "71d4c2cb82599e61a4443b97e30d9b1e",
"manifest.json": "b319ffeb60db4e1f85769f8e7d4b2120"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
