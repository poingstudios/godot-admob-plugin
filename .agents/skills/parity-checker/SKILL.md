---
name: parity-checker
description: Ensure API parity between GDScript and C#. Use when adding new methods, signals, or features to the plugin bridge to verify that Mono users have identical functionality.
---

# 👯 AdMob API Parity Checker

Ensure that GDScript and C# implementations remain synchronized and consistent.

## ⚖️ The Parity Standard

### 1. Method Naming
- **GDScript**: `snake_case` (e.g., `load_ad`)
- **C#**: `PascalCase` (e.g., `LoadAd`)
- **Note**: Internal `_plugin.Call("method_name")` must always use the EXACT string defined in the native bridge (usually `snake_case`).

### 2. Implementation Check
For every new feature in `admob.gd`:
- [ ] Create/Update the corresponding `.cs` class in `csharp/src/Api/`.
- [ ] Ensure `SafeConnect` is used for signals in C#.
- [ ] Verify that all optional parameters have the same default values in both languages.

### 3. Sample Sync
- [ ] Every new API feature, class, method, or modification MUST be added to the sample projects (`platforms/godot_editor/addons/admob/{gdscript,csharp}/sample/`) for interactive testing and verification.
- [ ] Maintain 1:1 functional, visual, and layout parity between GDScript and C# sample tabs and scenes.
- [ ] Verify that the C# sample actually instantiates or calls the classes (to trigger Static Initializers/Warnings).

## 🛠️ Verification Command
- Run `grep -r "_get_plugin" .` and `grep -r "GetPlugin" .` to compare list of initialized modules.
