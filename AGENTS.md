# 🤖 Project Intelligence: Godot AdMob Editor Plugin

This file is the authoritative source of truth for ALL AI agents (Gemini, Claude, Cursor). 
**Read this first** to minimize token usage and ensure architectural consistency.

## 🏗️ Repository Overview & Architecture

### What is this repository?
This repository is a Godot plugin that integrates the Google AdMob SDK into Godot Engine projects. It supports both GDScript and C#, and uses native plugins (Android and iOS) to interact with the official Google Mobile Ads SDKs.

### Folder Structure
- **`platforms/godot_editor/`**: The core Godot plugin and sample project.
  - `addons/admob/`: The actual plugin distributed to users.
    - `admob.gd`: Main entry point and public API.
    - `internal/`: Internal GDScript logic. **Rule: No `class_name` here, use `preload`.**
    - `csharp/`: C# wrappers and bridge, mirroring the GDScript API. Managed by `CSharpService.gd` (auto-hides via `.gdignore`).
- **`platforms/android/`**: Android native plugin source code (Kotlin/JNI).
- **`platforms/ios/`**: iOS native plugin source code (Swift/Obj-C).
- **`docs/`**: Official documentation built with MkDocs.
- **`scripts/`**: Automation scripts (e.g., building native plugins).
- **`tmp/`**: Reference implementations and external source code.

### Cross-Platform Communication
1. **Godot ➡️ Native**: The Godot scripts (GDScript/C#) use Godot's `Engine.get_singleton()` to access native plugins registered by the Android or iOS code. Method calls to these singletons trigger the native Google Mobile Ads SDK functions.
2. **Native ➡️ Godot**: The Android and iOS plugins emit signals back to Godot to communicate asynchronous events (e.g., ad loaded, ad failed to load, user rewarded). The Godot side connects to these signals and forwards them to the game developer's code.
3. **C# ↔️ GDScript**: The C# API acts as a wrapper around the GDScript implementation or Engine singletons to guarantee 1:1 API parity.

## 📦 Current Environment
- **Godot Version:** 4.7.1 (Current target for builds and testing).

## 🛠️ Critical Commands
- **Build All/Specific Platforms:** Use the central script for all compilation needs. 
  - ` ./scripts/build_local.sh [android|ios|all] <godot_version>`
  - *Example (All):* `./scripts/build_local.sh all 4.7.1`
  - *Example (iOS):* `./scripts/build_local.sh ios 4.7.1`
  - *Example (Android):* `./scripts/build_local.sh android 4.7.1`
- **Local Documentation Preview:**
  - Standard (Stable preview): `mkdocs serve`
  - Development (Master/Latest preview with banner): `mkdocs serve -f mkdocs.dev.yml`
- **GitHub CLI:** Use `gh` to check status of `issues` or `prs`.

## 📝 Coding Standards
- **License Header:** EVERY new source code file (e.g. `.gd`, `.cs`, `.kt`, `.swift`, `.java`) MUST start with the project's MIT License header (excluding documentation, Markdown/SKILL.md, and configuration files).
- **GDScript:** Always use `:=` for type inference. Prefix bridge signals with `_on_admob_`.
- **Linting:** Always run `gdlint platforms/godot_editor/addons/` and verify/fix errors before proposing changes.
- **C#:** Use PascalCase. Maintain 1:1 parity with the GDScript API.
- **Samples:** Always use platform-specific test Ad Unit IDs with ternary operators (GDScript) or properties (C#). Verify IDs against `docs/enable_test_ads.md`.
- **Mock Ads Parity:** Whenever changes are made to any ad format layout or behavior, the corresponding mock plugins must be updated as well. Maintain 1:1 functional and layout parity between C# and GDScript mock implementations (and vice versa) at all times.

## 🔄 Specialized Protocols (Skills)
When performing these specific tasks, you **MUST** read and follow the specialized guides:
- **Cross-Platform Sync:** [.agents/skills/sync/SKILL.md](.agents/skills/sync/SKILL.md)
- **API Parity Check:** [.agents/skills/parity-checker/SKILL.md](.agents/skills/parity-checker/SKILL.md)
- **Release Management:** [.agents/skills/release-manager/SKILL.md](.agents/skills/release-manager/SKILL.md)
- **Documentation Sync:** [.agents/skills/doc-master/SKILL.md](.agents/skills/doc-master/SKILL.md)

## 🚫 Constraints & Security
- **Security:** Never log/commit API Keys or `.env` files.
- **All Agents:** Permissions and context are managed via `.agents/settings.json`.
- **Gemini:** Respect `.geminiignore` patterns.
- **Workflow:** Reproduce bugs with a script before implementing a fix. Never stage/commit unless asked.

## 📋 Pending Tasks
- Verify iOS runtime behavior for App Open Ads in production environments.

## 🔗 Key Files
- `platforms/godot_editor/addons/admob/admob.gd` (Main API)
- `platforms/android/build.gradle` (Android Deps)
- `platforms/ios/Package.swift` (iOS Deps)
- `docs/enable_test_ads.md` (Source of truth for Test IDs)
