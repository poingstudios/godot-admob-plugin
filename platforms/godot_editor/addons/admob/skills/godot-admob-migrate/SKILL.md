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
3.  **Android App ID Migration & config.gd Removal**:
    *   **Extract Android App ID**: Read the `APPLICATION_ID` constant from `res://addons/admob/android/config.gd` (if upgrading an existing project).
    *   **Save to Project Settings**: Transfer the Android App ID into `project.godot` under `[admob]` section as `general/android/app_id="your-app-id"` (or via **Project Settings > General > Admob**).
    *   **Remove config.gd**: `config.gd` is deprecated and removed in v5; all settings are now managed via Project Settings.
4.  **AdPosition Class Migration**: `AdPosition.Values` enum is replaced by `AdPosition` static instances (e.g. `AdPosition.TOP` or `AdPosition.custom(x, y)`). Update your code references.
5.  **iOS Export Cleanup & App ID Migration**:
    *   **Delete AdMob `.gdip` files & binaries**: Delete all legacy `poing-godot-admob*.gdip` files and the `res://ios/plugins/poing-godot-admob/` directory inside `res://ios/plugins/` (do not delete the outer `plugins/` folder if other non-AdMob plugins exist). Version 5 injects frameworks dynamically during export, so leaving old `.gdip` files and binaries will cause `Multiple commands produce ...` build errors in Xcode.
    *   **Transfer iOS App ID**: Move the iOS App ID (formerly set in `Gad Application Identifier` in Export Presets or `.gdip`) into `project.godot` under `[admob]` section as `general/ios/app_id="your-app-id"` (or via **Project Settings > General > Admob**).
    *   **Clear Export Presets**: Clear the `Gad Application Identifier` field and uncheck legacy AdMob plugin checkboxes in your iOS Export Preset settings to avoid duplicate injection.
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

