# 📦 Mintegral Plugin (Flutter)

A Flutter plugin to integrate **Mintegral** Interstitial Ads. Easily initialize the SDK, load interstitial ads, and display them.

---

## ✅ Features

- ✅ SDK Initialization with callbacks
- ✅ Load Interstitial Ads
- ✅ Show Loaded Ads
- ✅ Custom `InterstitialAd` wrapper for ease of use

---

## 📦 Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  mintegral_plugin:
    path: ./path_to_your_plugin_directory
```

> Replace the path with the actual local path where your plugin code is stored.

---

## ⚙️ Android Setup

1. Add the required SDK dependencies in `build.gradle`.
2. Add necessary permissions and metadata in your `AndroidManifest.xml`.

---

## 🧑‍💻 Usage

### 1️⃣ Initialize SDK

```dart
MintegralPlugin.initialize(
  appId: 'your_app_id',
  appKey: 'your_app_key',
  onInitSuccess: () {
    print('Mintegral SDK initialized successfully');
  },
  onInitFail: (error) {
    print('Mintegral SDK initialization failed: $error');
  },
);
```

---

### 2️⃣ Load Ad (Interstitial)

```dart
MintegralPlugin.loadAd(
  placementId: 'your_placement_id',
  unitId: 'your_unit_id',
  adLoadCallback: (ad, {error}) {
    if (ad != null) {
      print('Ad loaded successfully');
      ad.show(); // Show the ad when ready
    } else {
      print('Failed to load ad: $error');
    }
  },
);
```

---

## 📄 Method Summary

| Method | Description |
|--------|-------------|
| `initialize` | Initializes the Mintegral SDK with `appId` and `appKey` |
| `loadAd` | Loads an interstitial ad with a placement & unit ID |
| `showAd` | Displays the loaded interstitial ad |
| `InterstitialAd.show()` | Convenience method to show the ad instance |

---

## 🧪 Testing Tips

- Use test `placementId` and `unitId` for development.
- Ensure initialization is complete before calling `loadAd`.

---

## 📃 License

MIT License — free to use, modify, and distribute.