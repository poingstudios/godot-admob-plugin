# 🤖 Project Intelligence: Godot AdMob Editor Plugin

This file is the authoritative source of truth for ALL AI agents (Gemini, Claude, Cursor). 
**Read this first** to minimize token usage and ensure architectural consistency.

## 🏗️ Repository Architecture
- **GDScript (Core):** `platforms/godot_editor/addons/admob/`
  - `admob.gd`: Main entry point.
  - `internal/`: Logic. **Rule: No `class_name` here, use `preload`.**
- **C# Bridge:** `platforms/godot_editor/addons/admob/csharp/`
  - Mirrors GDScript API. Managed by `CSharpService.gd` (auto-hides via `.gdignore`).
- **Native Bridges:** Android (Kotlin/JNI) in `platforms/android/`, iOS (Swift/Obj-C) in `platforms/ios/`.

## 🛠️ Critical Commands
- **Build Android:** `cd platforms/android && ./gradlew assembleDebug`
- **Build iOS:** `cd platforms/ios && scons platform=ios`
- **Build All:** `./scripts/build_local.sh`

## 📝 Coding Standards
- **License Header:** EVERY new file MUST start with the project's MIT License header.
- **GDScript:** Always use `:=` for type inference. Prefix bridge signals with `_on_admob_`.
- **C#:** Use PascalCase. Maintain 1:1 parity with the GDScript API.

## 🔄 Specialized Protocols (Skills)
When performing these specific tasks, you **MUST** read and follow the specialized guides:
- **Cross-Platform Sync:** [.github/ai/skills/sync/SKILL.md](.github/ai/skills/sync/SKILL.md)
- **API Parity Check:** [.github/ai/skills/parity-checker/SKILL.md](.github/ai/skills/parity-checker/SKILL.md)
- **Release Management:** [.github/ai/skills/release-manager/SKILL.md](.github/ai/skills/release-manager/SKILL.md)
- **Documentation Sync:** [.github/ai/skills/doc-master/SKILL.md](.github/ai/skills/doc-master/SKILL.md)

## 🚫 Constraints & Security
- **Security:** Never log/commit API Keys or `.env` files.
- **Claude:** Exclusion is managed via `permissions.deny` in `.claude/settings.json`.
- **Gemini:** Respect `.geminiignore` patterns.
- **Workflow:** Reproduce bugs with a script before implementing a fix. Never stage/commit unless asked.

## 📋 Pending Tasks
- Verify iOS runtime behavior for the new warning system.
- Sync new `CSharpService` rules to documentation if needed.

## 🔗 Key Files
- `platforms/godot_editor/addons/admob/admob.gd` (Main API)
- `platforms/android/build.gradle` (Android Deps)
- `platforms/ios/Package.swift` (iOS Deps)
