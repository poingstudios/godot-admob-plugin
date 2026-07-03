---
name: mediation
description: Create and maintain mediation network plugins (e.g., AppLovin, Vungle, Meta, IronSource) across Godot, C#, Android, and iOS.
---

# Mediation Network Development & Maintenance Guide

This guide outlines the architecture and step-by-step instructions for adding or maintaining AdMob mediation adapters (e.g., Meta, IronSource, Vungle, AppLovin) within the Godot AdMob Editor Plugin.

---

## 🏗️ Architecture Overview

Mediation integration consists of native Android/iOS libraries, GDScript/C# interface wrappers, and editor export configurations:

```
                  ┌────────────────────────────────┐
                  │          Game Project          │
                  └───────────────┬────────────────┘
                                  │ (API Calls)
                                  ▼
    ┌─────────────────────────────────────────────────────────────┐
    │                        Godot Addon                          │
    │  - AppLovin.gd (GDScript Wrapper)                           │
    │  - AppLovin.cs (C# Parity Wrapper)                          │
    │  - project_settings_service.gd (registers settings)         │
    │  - export_plugins (copies AARs/XCFrameworks)                │
    └──────────────────────┬──────────────────────────────┬───────┘
                           │ (JNI / Android Bridge)       │ (Objective-C++ / iOS Bridge)
                           ▼                              ▼
    ┌──────────────────────────────┐              ┌──────────────────────────────┐
    │        Android Library       │              │         iOS Framework        │
    │ - PoingGodotAdMobAppLovin.kt │              │ - PoingGodotAdMobAppLovin.mm │
    │ - play-services-ads-applovin │              │ - AppLovinAdapterTarget      │
    │ - AppLovin SDK (AAR)         │              │ - AppLovin SDK (XCFramework) │
    └──────────────────────────────┘              └──────────────────────────────┘
```

---

## 🛠️ Step-by-Step Implementation Guide

### 1. Editor Settings Registration
Add the setting to [project_settings_service.gd](file:///Volumes/Mac500GB/GitHub/Godot-AdMob-Editor-Plugin/platforms/godot_editor/addons/admob/internal/services/project_settings_service.gd):
```gdscript
SettingDefinition.new(ANDROID_MEDIATION_PREFIX + "network_name", TYPE_BOOL, false)
```

### 2. Public GDScript API Wrapper
Create `<NetworkName>.gd` inside `platforms/godot_editor/addons/admob/gdscript/src/mediation/extras/<network_name>/`:
- Must inherit `MobileSingletonPlugin`.
- Use type-safe `:=` operators.
- Register under class name `<NetworkName>`.
- Add a setup and usage example in [Main.gd](file:///Volumes/Mac500GB/GitHub/Godot-AdMob-Editor-Plugin/platforms/godot_editor/addons/admob/gdscript/sample/Main.gd) inside `_setup_mediation_adapters()`.

### 3. C# Wrapper Parity
Create `<NetworkName>.cs` in `platforms/godot_editor/addons/admob/csharp/src/Mediation/Extras/<NetworkName>/`:
- Match 1:1 API parity with the GDScript wrapper.
- Use `PascalCase` for method names, bridging to the `snake_case` GDScript plugin calls.
- Add a setup and usage example in [MainCSharpExample.cs](file:///Volumes/Mac500GB/GitHub/Godot-AdMob-Editor-Plugin/platforms/godot_editor/addons/admob/csharp/sample/MainCSharpExample.cs) inside `SetupMediationAdapters()`.

---

### 4. Android Native Implementation

1. **Register Module**: Add `include ':src:mediation:<network_name>'` to `platforms/android/settings.gradle`.
2. **Build Configuration**: Create `build.gradle` pulling dependencies from the GDScript config.
3. **AndroidManifest**: Create `src/main/AndroidManifest.xml` registering your `org.godotengine.plugin.v2.PoingGodotAdMob<NetworkName>` metadata.
4. **Kotlin Plugin Class**: Implement `PoingGodotAdMob<NetworkName>(godot: Godot?)` inheriting `GodotPlugin` and exposing methods annotated with `@UsedByGodot`.
5. **Addon Export configuration**:
   - Create `config/poing_godot_admob_<network_name>.gd` declaring your dependency coordinates (e.g., `"com.google.ads.mediation:applovin:x.y.z.w"`).
   - Register the library name in [export_plugin.gd (Android)](file:///Volumes/Mac500GB/GitHub/Godot-AdMob-Editor-Plugin/platforms/godot_editor/addons/admob/internal/exporters/android/export_plugin.gd) arrays `KNOWN_LIBS` and `MEDIATION_LIBS`.

---

### 5. iOS Native Implementation

1. **SCons Configuration**: Modify [SConstruct](file:///Volumes/Mac500GB/GitHub/Godot-AdMob-Editor-Plugin/platforms/ios/SConstruct) to add the new platform option to `plugin` and include the path to your `.xcframework` dependencies in `FRAMEWORKPATH`.
2. **iOS GDIP Config**:
   - Create `config/poing-godot-admob-<network_name>.gdip` under `platforms/ios/src/mediation/<network_name>/config/` declaring SPM package rules.
   - **Crucial SPM Tip**: Swift Package Manager uses Semantic Versioning (`major.minor.patch`). For 4-component mediation versions (e.g., `13.6.3.0`), multiply the patch component by 100 (e.g., use `13.6.300`).
   - Create an identical copy under `platforms/godot_editor/ios/plugins/` using the `admob_packages` array format.
3. **Objective-C++ Wrapper**:
   - Implement `PoingGodotAdMob<NetworkName>.h` & `.mm` referencing `<NetworkNameSDK/NetworkNameSDK.h>`.
   - Implement `PoingGodotAdMob<NetworkName>Module.h` & `.mm` to register the plugin singleton with the engine during initialization.

---

### 6. Create Documentation Page

Create a new Markdown documentation file `<network_name>.md` under `docs/mediate/integrate_partner_networks/`:
- Document the supported integrations (bidding/waterfall) and ad formats.
- Detail SDK imports for both Android and iOS.
- Describe how to enable the plugin in both Project Settings and Export Presets.
- Provide GDScript and C# code snippets for GDPR, CCPA, and any custom SDK configuration methods (such as audio controls).

---

## 🧪 Validation & Compilation

### Android
Verify module compilation by running:
```bash
./gradlew build
```

### iOS Swift Packages
Verify Swift Package Manager dependency resolution:
```bash
swift package resolve
```

### iOS compilation
Compile the static library using SCons:
```bash
scons plugin=<network_name> arch=arm64 target=debug
```

### Full Addon Rebuild
Generate and package all binaries into the editor addon directory using the main build script:
```bash
./scripts/build_local.sh all <godot_version>
```

### Logging & Diagnostics
- **Optional singletons (`is_required := false`)**: When a mediation plugin (like AppLovin) is disabled in Project Settings, the GDScript wrapper uses `push_warning` rather than `printerr`.
- **Logcat visibility**: In mobile builds (Android/iOS) without a debugger attached, Godot's `push_warning` is not outputted to standard console streams, meaning it will not appear in `adb logcat` logs. To force-print missing singleton messages to logcat, you must temporarily set `is_required := true` in the adapter wrapper initialization (which uses `printerr`).

---

## 🚫 Constraints & Security
- **No Browser Usage**: Do NOT launch browser subagents to research versions or view documentation. Always use terminal-based commands (such as `curl`, `git ls-remote`, or the native `read_url_content` tool) to inspect packages, repositories, or documentation pages.
- **Consult Official Documentation**: Before integrating any new mediation network, read the official Google AdMob mediation documentation for Android & iOS to ensure version compatibility. The URLs follow this pattern (replace `<network_name>` with the target mediation name in lowercase, e.g., `vungle`, `bidmachine`):
  - Android: `https://developers.google.com/admob/android/mediation/<network_name>`
  - iOS: `https://developers.google.com/admob/ios/mediation/<network_name>`
- **Dependency Coordinates**: Consult the dependency version tables in the official guides to retrieve the correct adapter coordinate (e.g., `com.google.ads.mediation:<network_name>:<version>`).
- **Never Commit**: Do not commit code or create branches unless explicitly instructed by the user.

