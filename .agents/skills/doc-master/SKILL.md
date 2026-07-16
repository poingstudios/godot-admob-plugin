---
name: doc-master
description: Synchronize documentation with code changes. Use when modifying APIs, installation steps, or project requirements to ensure MkDocs, README, and AGENTS.md are accurate.
---

# AdMob Doc Master Protocol

Keep all project documentation in sync with the codebase.

## 📝 Sync Requirements

### 1. Code to Docs & Navigation
- **Static Navigation**: All navigation structures must be defined statically in the `nav` block of `mkdocs.yml`. Avoid using `.pages` files to prevent plugin conflicts and 404 routing errors during i18n compilation.
- **New Ad Format / Page**: Create the new `.md` file in the appropriate directory, add it to the `nav` section in `mkdocs.yml`, and add its translation key to `nav_translations` for each language.
- **API Change**: Update the code blocks in the relevant `docs/` files for both GDScript and C#.
- **Class Links**: When referencing plugin classes, resources, or enums (e.g. `AdPosition`, `AdSize`, `AdView`), always link them to their corresponding documentation in `reference/classes/<ClassName>.md` or `reference/enums/<EnumName>.md` to maintain documentation connectivity.
- **Requirement Change**: If a plugin becomes mandatory/optional, update `AGENTS.md` and the error description files in `docs/errors/`.

### 2. Manual Installation
- **Release Assets**: If the release filename pattern changes in `release_matrix.yml`, update the "Manual Installation" section in `README.md`.

### 3. Cross-Platform Docs
- Ensure Android and iOS setup steps are verified when a new dependency is added to `build.gradle` or `Package.swift`.
- **SDK Version Changes**: When the Google Mobile Ads SDK or UMP version changes in Android Gradle or iOS Swift Package Manager configurations, you must update these version numbers in the Native SDK Versions list in `docs/index.md` (and all its localization files) and `AGENTS.md`.

### 4. Localization Parity
- **Primary Source**: English (`en`) is the source of truth. All new pages and layout changes must start in English first before translating.
- **Supported Locales**: The current target locales are English (`en`), Brazilian Portuguese (`pt-BR`), Spanish (`es`), Simplified Chinese (`zh`), and Japanese (`ja`).
- **1:1 Structure**: Any localized/translated documentation page (e.g., `.pt-BR.md`, `.es.md`, `.zh.md`, `.ja.md`) MUST have the exact same headings, content structure, code blocks, anchors, and internal layout as the default English page.
- **Custom Overrides**: When adding support for a new locale, always define the translations for the announcement header banner and footer copyrights in `docs/overrides/partials/translations.html`.
- **Synchronous Updates**: When adding new features, sections, or correcting code examples in the default `.md` files, also apply the same updates immediately to all translated files of that page.

## 🛠️ Documentation Tools
- **Build Docs**: `mkdocs build`
- **Serve Docs**: `mkdocs serve` (check for broken links and formatting).

## 🚫 Workflow Rules
- Never commit code changes without checking if they impact the documentation.
- Prioritize updating the `README.md` for any breaking installation changes.
- Ensure translated documentation files have 1:1 structural parity with their English counterparts.
- **Continuous Improvement**: When finding any new documentation pattern, improvement, or layout requirement, update this `SKILL.md` immediately with the new findings to keep all developers and AI agents aligned.
