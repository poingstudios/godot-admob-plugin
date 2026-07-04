# Enable Test Ads

!!! note "Godot 3 (v1) Documentation"
    This page is for **Godot 3.x**. For **Godot 4.2+**, see the [latest documentation](https://poingstudios.github.io/godot-admob-plugin/stable/).

During development, it is crucial to use test ads to avoid generating invalid traffic and risking your AdMob account suspension.

---

## 1. Preview Mock Ads in Editor

The plugin comes with a built-in Mock Ad system. You can test your ad integration visual layouts directly inside the Godot Editor without deploying to a physical device. 

For more details, see [Preview Mock Ads in Editor](editor_mock_ads.md).

---

## 2. Using Google's Sample Ad Units

The easiest way to enable testing on physical devices or emulators is by using Google's public test ad units. 

Use an iOS test ad unit for testing on iOS and an Android test ad unit for testing on Android:

=== "Android"

    | Ad format             | Sample ad unit ID                      |
    |-----------------------|----------------------------------------|
    | Banner                | `ca-app-pub-3940256099942544/6300978111` |
    | Interstitial          | `ca-app-pub-3940256099942544/1033173712` |
    | Rewarded              | `ca-app-pub-3940256099942544/5224354917` |
    | Rewarded Interstitial | `ca-app-pub-3940256099942544/5354046379` |

=== "iOS"

    | Ad format             | Sample ad unit ID                      |
    |-----------------------|----------------------------------------|
    | Banner                | `ca-app-pub-3940256099942544/2934735716` |
    | Interstitial          | `ca-app-pub-3940256099942544/4411468910` |
    | Rewarded              | `ca-app-pub-3940256099942544/1712485313` |
    | Rewarded Interstitial | `ca-app-pub-3940256099942544/6978759866` |

!!! warning "Important"

    Remember to replace these test IDs with your own production Ad Unit IDs before publishing your game to the app stores.

---

## 3. Registering Test Devices

Android emulators and iOS simulators are automatically configured as test devices. 

If you want to test on your own physical device, you can register it as a test device in your AdMob console:
1. Open your AdMob dashboard.
2. Navigate to **Settings -> Test devices**.
3. Click **Add test device** and enter your device details.
