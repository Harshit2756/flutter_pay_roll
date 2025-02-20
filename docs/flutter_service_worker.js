'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "0e82fbef313bab62d1971805c78d28ad",
"icons/Icon-192.png": "905289df6f844de76c197fa8bc97b7a0",
"flutter_bootstrap.js": "3c0ff1d22732fa5aac24d0769fba68df",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"main.dart.js": "f4b73025a6babd5742b0989f5938ef60",
"version.json": "238db54f824e7bd889c6e8d2fd8087a9",
"assets/packages/flutter_neumorphic_plus/fonts/NeumorphicIcons.ttf": "32be0c4c86773ba5c9f7791e69964585",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/FontManifest.json": "cd0edd060da8b0a26c9e110486e78c06",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "61e62fd01a9a0f0db5b515a25cac97ef",
"assets/assets/images/planning.png": "294d04efb07ace6be6e365ee63eb26f2",
"assets/assets/images/welcome.png": "3d0c4ae95f719ff9e35530316c36c75c",
"assets/assets/images/favicon.ico": "47c44f6dd83b9a75a47dc3c04f444e16",
"assets/assets/images/punch.png": "0e2de64e61b59a55ddca56886a8be7fe",
"assets/assets/images/background.png": "f625d0fa73f9d272bca054774279c834",
"assets/assets/images/holiday1.png": "4d9c7e7273bd0c6b679f0d0a48cd5f15",
"assets/assets/images/user.png": "e960a908111657f9219e9f573d84acf7",
"assets/assets/images/punch_out.png": "a0c14371866b8bb003f05be9b5c992fd",
"assets/assets/images/logo.png": "cdbee4e9b6e52642391a5906f08fd744",
"assets/assets/images/total_hours.png": "ee3e5ddda54df3dc11973a15103dc8cb",
"assets/assets/images/punch_in.png": "4ff15b47555a2b32e254009517233623",
"assets/assets/images/request.png": "50873d0abc12671e6f8f1dbe16db6903",
"assets/assets/images/profile.png": "d78b5160522cf704c3299675feb4a4b3",
"assets/assets/images/holidays.png": "fbf2db25aadea16dd4fabc82f711cb42",
"assets/assets/images/payslip.png": "8e862fa8bc5aa732e31534ad4b08f665",
"assets/assets/images/adp_logo.png": "a99486388c58b7bc3f0e85c0b2051507",
"assets/assets/images/history.png": "7241e362e367f5b893d904bbc039dc5e",
"assets/assets/images/leave_req.png": "745ff3679c49d3446df4990bd154d2b6",
"assets/assets/images/fingerprint.png": "698be554b567d5d74e799db3231e10d5",
"assets/NOTICES": "deae7d0ccb57cf3dd48dc5f91adbf8e3",
"assets/AssetManifest.bin": "d004259828c53ade622e0ef5da5a5ed0",
"assets/fonts/MaterialIcons-Regular.otf": "f4343b3c836d2c880f05c138745babb6",
"assets/AssetManifest.bin.json": "25c0e72d498fb96f237d5763ddfd5013",
"splash/img/dark-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/light-4x.png": "8102a9ac36397233499672203e8a3a9e",
"splash/img/branding-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/dark-2x.png": "ac97310efd643398f40f00385b17977a",
"splash/img/branding-2x.png": "ac97310efd643398f40f00385b17977a",
"splash/img/light-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/dark-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/branding-dark-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/branding-dark-2x.png": "ac97310efd643398f40f00385b17977a",
"splash/img/branding-dark-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/dark-4x.png": "8102a9ac36397233499672203e8a3a9e",
"splash/img/branding-4x.png": "8102a9ac36397233499672203e8a3a9e",
"splash/img/light-1x.png": "47667442d836fc95a91ee00f296724dc",
"splash/img/branding-3x.png": "ac16abef613a0d581ae4c58b7b03099f",
"splash/img/branding-dark-4x.png": "8102a9ac36397233499672203e8a3a9e",
"splash/img/light-2x.png": "ac97310efd643398f40f00385b17977a",
"favicon.png": "b2d4ab31c69b351844accdaf816efd3d",
"index.html": "fce476ab11b1dcc324a03014de066107",
"/": "fce476ab11b1dcc324a03014de066107",
"manifest.json": "a1c3e91ad1a05665cc3b9a994eeefcf3",
"flutter.js": "76f08d47ff9f5715220992f993002504"};
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
