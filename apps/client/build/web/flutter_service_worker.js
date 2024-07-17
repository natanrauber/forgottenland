'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "ddbe14e1e62456aa7e9791fbc07bd19e",
"assets/AssetManifest.bin.json": "d176347713b1f62a34b952103db8a592",
"assets/AssetManifest.json": "5fe83900fc3b599b03de845bd0a19ced",
"assets/assets/creatures/skeleton.gif": "66386cce6b06e7e1f9b6a5bfc20900b0",
"assets/assets/favicon.png": "0017b6b780af4d2e45443254c296bc2d",
"assets/assets/fonts/MartianMono/MartianMono.ttf": "57c5283f93150a30e372b120eecac3eb",
"assets/assets/icon.png": "e69b3f29e48939e53f8a523792f8abfa",
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
"assets/assets/images/sponsor/sponsor.png": "e28821bea8805732d66420a8d580930e",
"assets/assets/logo.jpg": "d063f353bee5c15e6672cddc0d32b0c8",
"assets/assets/logo_alt.png": "9f60c32b8e2732f45130ab9169642ead",
"assets/assets/outfit/awkn.png": "6ed840ff0ab909c7425bad4879567889",
"assets/assets/outfit/draven.png": "81411cb7dae9de52bc297716d73bcf1c",
"assets/assets/outfit/junck.png": "910f2ce26dbec8f5faee6b1a547bc380",
"assets/assets/outfit/karkaroff.png": "09be0b26ce34161a6249d0598e1bc8d9",
"assets/assets/scroll.png": "23cc4d423c57bd8f6857c1975f3df3d8",
"assets/assets/svg/logo.svg": "3d61ab16145684e9f16bf22b1ac8832a",
"assets/assets/svg/logo1.svg": "50d2ddf70f77a061eefea7162fb68fd7",
"assets/assets/svg/logo2.svg": "e342daaea85f3b3db4cc72664a42c11e",
"assets/FontManifest.json": "5a755bb0baae182a01aeb04231d978e6",
"assets/fonts/MaterialIcons-Regular.otf": "0287a33ab1db78dfca0520a49daef8f3",
"assets/NOTICES": "fdba8027b1af28b62187af3671274740",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "58f2b12f0e25cb28d966ed7a56f51706",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "6f5eec31a210f5c8f9c2c3a3e6e6db24",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "56c2ac33a5293e62185c562cd7cdff33",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "60d244f278554c02b48f65affcff5372",
"icons/Icon-512.png": "29ad10dd0d727da937be68004807a0e4",
"icons/Icon-maskable-192.png": "60d244f278554c02b48f65affcff5372",
"icons/Icon-maskable-512.png": "29ad10dd0d727da937be68004807a0e4",
"index.html": "e2142ac3aeca4ed4073a332a4ff193bb",
"/": "e2142ac3aeca4ed4073a332a4ff193bb",
"main.dart.js": "2b8862e0a9ea476ace65729adef28a7f",
"manifest.json": "2ed074af40a8adfa668039a1d47526a8",
"offline.jpg": "40a2833ddb19db0187660a8c90ad429c",
"version.json": "46acbcd943fdfecad4bbd89b18a35690"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
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
