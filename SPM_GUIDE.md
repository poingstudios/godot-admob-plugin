# Developer Guide: Swift Package Manager (SPM)

This project uses **Native Swift Package Manager** integration for managing dependencies (Google AdMob, Meta, and Liftoff/Vungle).

## 🚀 Getting Started

If you are just cloning the repository, the setup is almost entirely automatic:

1.  **Open the Project:**
    Open `PoingGodotAdMob.xcodeproj` in Xcode.

2.  **Automatic Resolution:**
    Xcode will detect the local `Package.swift` and start downloading the dependencies (Google SDKs) automatically.
    - You can monitor this in the top progress bar.
    - If it doesn't start, go to `File` -> `Packages` -> `Resolve Package Versions`.

3.  **Build:**
    - Choose the target you want (e.g., `ads`).
    - Select a destination (e.g., `Any iOS Device` or a Simulator).
    - Press `Cmd + B` to build.
    - The output binary (`.a`) will be saved in the `bin/` folder of the project.

---

## 🛠️ Troubleshooting (If things go wrong)

If you see linker errors (symbols not found) or the `PoingGodotAdMobDeps` package appears with a red icon:

### 1. Re-linking the local package
If the local package reference is broken:
- Drag the `Package.swift` file from the finder into the Xcode project sidebar. 
- It should appear as a package icon (white box) at the root of the project.

### 2. Double-check Framework Linking
The targets should already be linked. If they are not, select your target (e.g., `ads`) -> **General** -> **Frameworks, Libraries, and Embedded Content** and ensure **PoingGodotAdMobDeps** is present.

---

## 🏗️ Terminal / CI Workflow

The project can still be built via terminal, which is the recommended way to generate the final `.xcframework` for distribution:

```bash
# Optional: Pre-resolve dependencies
./scripts/lib/resolve_spm_deps.sh

# Build everything (generates standard .xcframework in the bin/ folder)
./scripts/build.sh
```

## ⚠️ Important Notes
- **No CocoaPods:** Do NOT run `pod install`. It is no longer supported.
- **Header Files:** Native SPM handles the headers. You don't need to manually configure search paths; Xcode manages this via the `PoingGodotAdMobDeps` library target.
- **Updating SDKs:** To update a dependency version, simply edit the `Package.swift` file and then run `File -> Packages -> Update to Latest Package Versions`.
