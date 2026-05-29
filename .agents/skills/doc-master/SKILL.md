---
name: doc-master
description: Synchronize documentation with code changes. Use when modifying APIs, installation steps, or project requirements to ensure MkDocs, README, and AGENTS.md are accurate.
---

# AdMob Doc Master Protocol

Keep all project documentation in sync with the codebase.

## 📝 Sync Requirements

### 1. Code to Docs
- **New Ad Format**: Create a new `.md` file in `docs/ad_formats/` and add it to `mkdocs.yml`.
- **API Change**: Update the code blocks in the relevant `docs/` files for both GDScript and C#.
- **Requirement Change**: If a plugin becomes mandatory/optional, update `AGENTS.md` and the error description files in `docs/errors/`.

### 2. Manual Installation
- **Release Assets**: If the release filename pattern changes in `release_matrix.yml`, update the "Manual Installation" section in `README.md`.

### 3. Cross-Platform Docs
- Ensure Android and iOS setup steps are verified when a new dependency is added to `build.gradle` or `Package.swift`.

## 🛠️ Documentation Tools
- **Build Docs**: `mkdocs build`
- **Serve Docs**: `mkdocs serve` (check for broken links and formatting).

## 🚫 Workflow Rules
- Never commit code changes without checking if they impact the documentation.
- Prioritize updating the `README.md` for any breaking installation changes.
