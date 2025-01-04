'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "0e82fbef313bab62d1971805c78d28ad",
"icons/Icon-192.png": "905289df6f844de76c197fa8bc97b7a0",
"assets/assets/images/planning.png": "294d04efb07ace6be6e365ee63eb26f2",
"assets/assets/images/history.png": "7241e362e367f5b893d904bbc039dc5e",
"assets/assets/images/background.png": "f625d0fa73f9d272bca054774279c834",
"assets/assets/images/profile.png": "d78b5160522cf704c3299675feb4a4b3",
"assets/assets/images/payslip.png": "8e862fa8bc5aa732e31534ad4b08f665",
"assets/assets/images/logo.png": "cdbee4e9b6e52642391a5906f08fd744",
"assets/assets/images/holidays.png": "fbf2db25aadea16dd4fabc82f711cb42",
"assets/assets/images/holiday1.png": "4d9c7e7273bd0c6b679f0d0a48cd5f15",
"assets/assets/images/punch.png": "0e2de64e61b59a55ddca56886a8be7fe",
"assets/assets/images/leave_req.png": "745ff3679c49d3446df4990bd154d2b6",
"assets/assets/images/punch_out.png": "a0c14371866b8bb003f05be9b5c992fd",
"assets/assets/images/request.png": "50873d0abc12671e6f8f1dbe16db6903",
"assets/assets/images/user.png": "e960a908111657f9219e9f573d84acf7",
"assets/assets/images/favicon.ico": "47c44f6dd83b9a75a47dc3c04f444e16",
"assets/assets/images/adp_logo.png": "a99486388c58b7bc3f0e85c0b2051507",
"assets/assets/images/total_hours.png": "ee3e5ddda54df3dc11973a15103dc8cb",
"assets/assets/images/punch_in.png": "4ff15b47555a2b32e254009517233623",
"assets/assets/images/fingerprint.png": "698be554b567d5d74e799db3231e10d5",
"assets/assets/images/welcome.png": "3d0c4ae95f719ff9e35530316c36c75c",
"assets/AssetManifest.bin": "e0126eb0eb652ba00b05d9edbbe3c47c",
"assets/NOTICES": "7f653a6dd546c3c17461dfd850f0aeae",
"assets/AssetManifest.json": "f187c0f31a718fb7b4024b988349fd3a",
"assets/fonts/MaterialIcons-Regular.otf": "24ddab1b3864fed74e64e2fc8f4818cc",
"assets/packages/flutter_neumorphic_plus/fonts/NeumorphicIcons.ttf": "32be0c4c86773ba5c9f7791e69964585",
"assets/FontManifest.json": "802771d6ac7cc453483470f1015fd4f7",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "8733baa7cf155af6c013c6576ae4d598",
"version.json": "238db54f824e7bd889c6e8d2fd8087a9",
"manifest.json": "a1c3e91ad1a05665cc3b9a994eeefcf3",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"splash/img/dark-4x.png": "8102a9ac36397233499672203e8a3a9e",
"splash/img/dark-2x.png": "ac97310efd643398f40f00385b17977a",
"splash/img/branding-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/branding-dark-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/light-2x.png": "ac97310efd643398f40f00385b17977a",
"splash/img/branding-2x.png": "ac97310efd643398f40f00385b17977a",
"splash/img/dark-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/branding-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/dark-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/branding-dark-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/branding-dark-4x.png": "8102a9ac36397233499672203e8a3a9e",
"splash/img/branding-dark-2x.png": "ac97310efd643398f40f00385b17977a",
"splash/img/light-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/light-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/light-4x.png": "8102a9ac36397233499672203e8a3a9e",
"splash/img/branding-4x.png": "8102a9ac36397233499672203e8a3a9e",
"index.html": "fce476ab11b1dcc324a03014de066107",
"/": "fce476ab11b1dcc324a03014de066107",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"favicon.png": "b2d4ab31c69b351844accdaf816efd3d",
"flutter_bootstrap.js": "86204ce406815d0f44eeab21e62f30da",
"main.dart.js": "79b2f0b33f7cd74efe42ead4cb04497c"};
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
