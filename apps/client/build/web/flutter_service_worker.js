'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "b47ef9d975bbf4ffdb6828f3f5318652",
"assets/AssetManifest.bin.json": "7cff78bec9d5da27ae855339e0341d97",
"assets/AssetManifest.json": "cae0fca1db4891bd44f03920df9fbee7",
"assets/assets/fonts/MartianMono/MartianMono.ttf": "57c5283f93150a30e372b120eecac3eb",
"assets/assets/icons/battleye_type/green.png": "04760c0dfe66cb7c60fc4e40696411ad",
"assets/assets/icons/battleye_type/none.png": "c2e4c427c21a5a45a2a966ee03e5b8c0",
"assets/assets/icons/battleye_type/yellow.png": "a6dcd931ab7868ffbb754215a5f348eb",
"assets/assets/icons/location/EU.svg": "a936a0c26c1624259170b9b84be4e418",
"assets/assets/icons/location/NA.svg": "e2482fc644d6c1c19d265b6cd827e536",
"assets/assets/icons/location/SA.svg": "f55a9ae3300649eb985c02c6b527da8a",
"assets/assets/icons/news_type/cipsoft.png": "1c38bacfb528b6a802ce5860e9521603",
"assets/assets/icons/news_type/community.png": "943dd15e91209dc73fd8babe04af02f4",
"assets/assets/icons/news_type/development.png": "81d90efa4b0c6be8d1f80491aa9de6e6",
"assets/assets/icons/news_type/support.png": "c9a05bbade6f242d4bb8cca8202cc1ba",
"assets/assets/icons/news_type/technical.png": "8b52a5922d7f93067304bff21e6b3dec",
"assets/assets/icons/pvp_type/hardcore_pvp.png": "e6fb9a8ea3c7d1034854fadd1eb55105",
"assets/assets/icons/pvp_type/open_pvp.png": "129905ee11875675db000123e8ac50a4",
"assets/assets/icons/pvp_type/optional_pvp.png": "7222e45988c1aa09317f1eb6179132f5",
"assets/assets/icons/pvp_type/retro_hardcore_pvp.png": "a0cd18501c886f9f2c16e1cd6c2ef1b2",
"assets/assets/icons/pvp_type/retro_open_pvp.png": "f008d05349d237bd1f19fb8183378bcd",
"assets/assets/icons/rank/globalrank1.png": "644d2cdb353a95ce1803b3cdf522101d",
"assets/assets/icons/rank/globalrank2.png": "bb127c4a7f1b686cacdaec29e95b3744",
"assets/assets/icons/rank/globalrank3.png": "1cba0dd592982012c364b09b75d70746",
"assets/assets/icons/rank/globalrank4.png": "281a2b3c59072223adf8761584fe1f01",
"assets/assets/icons/rank/rank1.png": "b2d8d06d976a2fdded9a6756b45f3be9",
"assets/assets/icons/rank/rank2.png": "4a8a3e88e1b9a32c0393a967f875a0b5",
"assets/assets/icons/rank/rank3.png": "04a40770c555a70bbd1e46e08a938da1",
"assets/assets/icons/rank/rank4.png": "8452e11602ee5afb7eb5b3c863f78854",
"assets/assets/icons/tibia_coin_trusted.png": "74c41bbf1d4b258dfcdf39db60c021ab",
"assets/assets/images/background/25th_anniversary.jpg": "5e1984966e44b0441402bde4d10de48a",
"assets/assets/images/background/offline.jpg": "40a2833ddb19db0187660a8c90ad429c",
"assets/assets/images/splash/tintas_merighi.jpeg": "318bfa14330f81be376ba6db7ecac033",
"assets/assets/logo.jpg": "d063f353bee5c15e6672cddc0d32b0c8",
"assets/assets/logo_alt.png": "9f60c32b8e2732f45130ab9169642ead",
"assets/assets/outfit/awkn.png": "6ed840ff0ab909c7425bad4879567889",
"assets/assets/outfit/draven.png": "81411cb7dae9de52bc297716d73bcf1c",
"assets/assets/outfit/freedan.png": "85d3c95decad74cb55df4e3aa27659ff",
"assets/assets/outfit/junck.png": "910f2ce26dbec8f5faee6b1a547bc380",
"assets/assets/outfit/karkaroff.png": "09be0b26ce34161a6249d0598e1bc8d9",
"assets/assets/scroll.png": "23cc4d423c57bd8f6857c1975f3df3d8",
"assets/assets/svg/logo.svg": "3d61ab16145684e9f16bf22b1ac8832a",
"assets/FontManifest.json": "5a755bb0baae182a01aeb04231d978e6",
"assets/fonts/MaterialIcons-Regular.otf": "ed3c7e6abd122c6dfce690b93d566741",
"assets/NOTICES": "7552527d6d32991da6e3a4618ae83c9c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "30f029ef0adeb23c35207fc8bca76d5f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "7590147f256c6480c77093c90376f99f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "a5d7457fda15b7622c14f432ba63039a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "b72c617acdf2227c8b1413215f620711",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "56c2ac33a5293e62185c562cd7cdff33",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "60d244f278554c02b48f65affcff5372",
"icons/Icon-512.png": "29ad10dd0d727da937be68004807a0e4",
"icons/Icon-maskable-192.png": "60d244f278554c02b48f65affcff5372",
"icons/Icon-maskable-512.png": "29ad10dd0d727da937be68004807a0e4",
"index.html": "42b2243f2c3902ed0943bb4ba0d81a34",
"/": "42b2243f2c3902ed0943bb4ba0d81a34",
"main.dart.js": "84932bc88d4d10dd1af1e39a69b3ac1a",
"manifest.json": "2ed074af40a8adfa668039a1d47526a8",
"offline.jpg": "40a2833ddb19db0187660a8c90ad429c",
"version.json": "957eb748bb34a4a2eafb9aae28778f2e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
