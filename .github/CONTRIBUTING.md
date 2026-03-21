# Contributing to Godot AdMob Plugin

Thank you for your interest in contributing to the Godot AdMob Plugin! This guide will help you get started with the development process.

## 🤝 How to Contribute

### Reporting Bugs
- Check the [existing issues](https://github.com/poingstudios/godot-admob-plugin/issues) to see if the bug has already been reported.
- If not, open a new issue with a clear title and description.
- Provide reproduction steps and, if possible, a minimal reproduction project.
- Include information about your Godot version and target platform (Android/iOS).

### Feature Requests
- Check [existing issues](https://github.com/poingstudios/godot-admob-plugin/issues) or [discussions](https://github.com/poingstudios/godot-admob-plugin/discussions).
- Open a new issue to discuss the feature before starting implementation.

## 💻 Development Setup

### Requirements
- **Godot 4.2+** (Standard or .NET edition).
- **Android**: Android Studio & SDK (minimum API 24).
- **iOS**: macOS with Xcode 15+ and SCons installed (`brew install scons`).
- **Python 3.x**: Required for Godot's build system and internal scripts.

### Workflow
1. Fork the repository.
2. Clone your fork locally.
3. Create a branch for your changes (`git checkout -b feature/my-new-feature`).

---

## 🛠️ Build Process

The plugin consists of a Godot editor component and native binaries for Android and iOS.

### General Build (Auto-updating the Editor Plugin)
To build the native binaries and automatically copy/extract them to the [`platforms/godot_editor/`](./platforms/godot_editor/) directory, use the provided local build script. **This script handles the export process automatically for the selected platform(s).**

- **Android** binaries are built via Gradle and exported to `platforms/godot_editor/addons/admob/android/bin/`.
- **iOS** binaries are built via SCons/SPM and extracted to `platforms/godot_editor/ios/plugins/`.

```bash
# Usage: ./scripts/build_local.sh [android|ios|all] <godot_version>
./scripts/build_local.sh all 4.6.1
```

### 🤖 Android Build Details
Located in [`platforms/android/`](./platforms/android/). Build and export are handled via Gradle.

- **Tools**: Android Studio / SDK.
- **Manual Build**:
  ```bash
  cd platforms/android
  ./gradlew build
  ./gradlew exportFiles -PpluginExportPath=../godot_editor/addons/admob/android/bin
  ```
- **Logging**: `adb logcat -s poing-godot-admob godot`

### 🍎 iOS Build Details
Located in [`platforms/ios/`](./platforms/ios/). Build is handled via a dedicated shell script.

- **Tools**: Xcode 15+, SCons.
- **Manual Build**:
  ```bash
  cd platforms/ios
  ./scripts/build.sh <godot_version>
  ```
- **Note**: This script generates the `.xcframework` files and headers. When using `./scripts/build_local.sh ios`, the resulting zip is automatically extracted to the editor plugin folder.

---

## 📜 Code Style & Principles

To maintain code quality and consistency, please follow these guidelines:

### General Principles
- **SOLID**: Always aim for clean, maintainable, and decoupled code.
- **Official SDK Consistency**: The goal of this plugin is to stay as close as possible to the official [Android](https://developers.google.com/admob/android) and [iOS](https://developers.google.com/admob/ios) AdMob SDKs.
- **No Global Scope Pollution**: Avoid adding unnecessary global names or classes.

### GDScript Guidelines
- **Style Guide**: Follow the [official Godot GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
- **Type Inference**: Use `:=` for type inference where possible to improve readability and safety.
- **Internal Scripts**: Scripts located inside `internal` folders **must not** use `class_name`. They should be accessed via `preload()` to keep the global namespace clean.

### C# Guidelines
- **Style Guide**: Follow the [official Godot C# style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/c_sharp_style_guide.html).
- **Namespaces**: Ensure proper use of namespaces to organize code effectively.

## 🚀 Pull Request Process
1. Ensure your code follows the style guidelines.
2. Update the documentation if you are adding or changing features.
3. Link the PR to the relevant issue.
4. Once submitted, a maintainer will review your changes.

Thank you for helping us make this plugin better!
