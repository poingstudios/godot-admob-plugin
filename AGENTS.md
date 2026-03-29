# 🤖 Project Intelligence: Godot AdMob Editor Plugin

This file is the authoritative source of truth for ALL AI agents (Gemini, Claude, Cursor). 
**Read this first** to minimize token usage and ensure architectural consistency.

## 🏗️ Repository Architecture
- **Primary Branch:** `master`
- **GDScript (Core):** `platforms/godot_editor/addons/admob/`
  - `admob.gd`: Main entry point.
  - `internal/`: Logic. **Rule: No `class_name` here, use `preload`.**
- **C# Bridge:** `platforms/godot_editor/addons/admob/csharp/`
  - Mirrors GDScript API. Managed by `CSharpService.gd` (auto-hides via `.gdignore`).
- **Native Bridges:** Android (Kotlin/JNI) in `platforms/android/`, iOS (Swift/Obj-C) in `platforms/ios/`.
- **Reference Source Code:** `tmp/`. Contains reference implementations for logic and architecture.

## 📦 Current Environment
- **Godot Version:** 4.6.1 (Current target for builds and testing).

## 🛠️ Critical Commands
- **Build All/Specific Platforms:** Use the central script for all compilation needs. 
  - ` ./scripts/build_local.sh [android|ios|all] <godot_version>`
  - *Example (All):* `./scripts/build_local.sh all 4.6.1`
  - *Example (iOS):* `./scripts/build_local.sh ios 4.6.1`
  - *Example (Android):* `./scripts/build_local.sh android 4.6.1`
- **GitHub CLI:** Use `gh` to check status of `issues` or `prs`.

## 📝 Coding Standards
- **License Header:** EVERY new file MUST start with the project's MIT License header.
- **GDScript:** Always use `:=` for type inference. Prefix bridge signals with `_on_admob_`.
- **C#:** Use PascalCase. Maintain 1:1 parity with the GDScript API.
- **Samples:** Always use platform-specific test Ad Unit IDs with ternary operators (GDScript) or properties (C#). Verify IDs against `docs/enable_test_ads.md`.

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
- Verify iOS runtime behavior for App Open Ads in production environments.

## 🔗 Key Files
- `platforms/godot_editor/addons/admob/admob.gd` (Main API)
- `platforms/android/build.gradle` (Android Deps)
- `platforms/ios/Package.swift` (iOS Deps)
- `docs/enable_test_ads.md` (Source of truth for Test IDs)
