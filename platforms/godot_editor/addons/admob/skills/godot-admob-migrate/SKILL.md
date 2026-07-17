---
name: godot-admob-migrate
description: Provides instructions to migrate your Godot AdMob project between different plugin versions (e.g. from version 4.x to version 5.x) in GDScript and C#. Use when upgrading plugin versions.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Migration Guide

Assists with migrating your Godot AdMob integration between different plugin versions in GDScript and C#.

## Migrate from v4.x to v5.x

### Steps

1.  **Remove SMART_BANNER Constants**: Replace any references to `AdSize.SMART_BANNER` or `SmartBanner` with Anchored Adaptive Banner sizes.
2.  **Update Fallbacks**: Ensure that any legacy layouts using `-1, -1` size fallback values are replaced with the recommended Anchored Adaptive Banner sizes.
3.  **Project Settings & config.gd**: `config.gd` has been removed. Transfer your App IDs to **Project Settings > General > Admob** for both Android and iOS.
4.  **AdPosition Class Migration**: `AdPosition.Values` enum is replaced by `AdPosition` static instances (e.g. `AdPosition.TOP` or `AdPosition.custom(x, y)`). Update your code references.
5.  **iOS Export Presets Cleanup**: It is critical to clear the `Gad Application Identifier` and uncheck the legacy `Ad Mob` options in your iOS Export Preset settings. Since version 5 automatically injects all frameworks and configurations via Project Settings, leaving them checked/filled will cause duplicate symbol errors and plugin conflicts.
6.  **Update Gradle Dependencies**: Clean and rebuild your Android plugin template if necessary to fetch the GMA Next-Gen SDK dependencies.
7.  **Review Initialization Defaults**: By default, initialization and ad loading optimizations are enabled. If you run into threading issues, toggle **Disable Initialization Optimization** and **Disable Ad Loading Optimization** in the Godot project settings under **Admob > General > Android**.
8.  **Download v5 Platform Binaries**: In the Godot Editor, open **AdMob Manager** and click **Download & Install** for both Android and iOS to download the new v5.0.0 native libraries. The export plugin will block project export if the installed native binaries are missing or legacy/v4 due to version mismatch protection.
9.  **Asynchronous SDK Initialization**: On Android (GMA Next-Gen SDK), initialization via `MobileAds.initialize()` is strictly asynchronous. You must wait for the callback (using `OnInitializationCompleteListener`) to fire before loading any ads. Attempting to load ads prior to initialization completion will throw an exception.

### Migration References

#### Size Migration

| Removed Constant (v4.x) | Recommended Alternative (v5.x) |
| :--- | :--- |
| `AdSize.SMART_BANNER` (GDScript) | `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)` |
| `AdSize.SmartBanner` (C#) | `AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth)` |

#### AdPosition Migration

| Removed Enum (v4.x) | Recommended Class Instance (v5.x) |
| :--- | :--- |
| `AdPosition.Values.TOP` (GDScript) | `AdPosition.TOP` |
| `AdPosition.Values.Top` (C#) | `AdPosition.Top` |
| Custom positions unsupported | `AdPosition.custom(x, y)` (GDScript) / `AdPosition.Custom(x, y)` (C#) |

