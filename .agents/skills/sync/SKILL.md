---
name: sync
description: Rigorous multi-platform feature synchronization for Godot AdMob. Use when adding or modifying ad formats, consent flows, or bridge methods to ensure GDScript, C#, Android, and iOS implementations are perfectly in sync.
---

# AdMob Cross-Platform Synchronization

Ensure every bridge feature is implemented consistently across all supported platforms and languages.

## 🔄 The "GDScript-First" Workflow

1. **Define in GDScript**: Update `platforms/godot_editor/addons/admob/admob.gd` or the specific ad format file. 
   - Use `:=` for type inference.
   - Use `snake_case` for methods.
2. **Mirror in C#**: Update the corresponding file in `platforms/godot_editor/addons/admob/csharp/`.
   - Use `PascalCase` for methods.
   - Ensure the internal `_plugin.Call("method_name")` matches the GDScript snake_case.
3. **Implement Android**: Update Kotlin source in `platforms/android/src/`.
   - Implement the JNI bridge method.
   - Match the signal names emitted back to Godot.
4. **Implement iOS**: Update Swift/Obj-C source in `platforms/ios/src/`.
   - Ensure SCons/SPM dependencies are updated if needed.

## 📋 Technical Mapping Reference

| Feature | GDScript | C# | Android (Kotlin) | iOS (Swift) |
| :--- | :--- | :--- | :--- | :--- |
| **Dictionary** | `Dictionary` | `Dictionary` | `Map<String, Any>` | `[String: Any]` |
| **Array** | `Array` | `Array<T>` | `List<T>` | `[T]` |
| **Signal** | `emit_signal` | `EmitSignal` | `emitSignal` | `emit_signal` |
| **Method** | `snake_case` | `PascalCase` | `camelCase` | `camelCase` |

## 🧪 Validation Steps

- [ ] **GDScript**: No parse errors in the editor.
- [ ] **C#**: Project compiles with Mono.
- [ ] **Android**: `./gradlew assembleDebug` succeeds.
- [ ] **iOS**: `scons platform=ios` (or Xcode build) succeeds.
- [ ] **Runtime**: Both GDScript and C# samples show the same behavior/warnings on mobile.

## 🚫 Constraints
- Never skip the C# implementation.
- Signals emitted from native MUST be prefixed with `_on_admob_` where applicable.
- Every new file MUST include the MIT License header.
