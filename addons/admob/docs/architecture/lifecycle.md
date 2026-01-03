# Plugin Lifecycle

This document outlines the lifecycle of the plugin upon activation, specifically regarding dependency management for Android and iOS.

## Activation & Dependency Checks

When the plugin is activated, it executes a pipeline to verify the integrity and version of its native dependencies.

### Android Flow
The Android setup is designed to be self-healing and semi-automated.

1.  **File Existence Verification**: The plugin checks if the file `res://addons/admob/android/bin/package.gd` exists.
2.  **Automatic Installation**: If the file is **missing**, the plugin automatically:
    *   Downloads the Android binaries.
    *   Unzips them into `res://addons/admob/android/bin/`.
3.  **Version Validation**: If the file **exists**, the plugin fetches the `VERSION` variable from the [godot-admob-versions](https://github.com/poingstudios/godot-admob-versions) repository.
    *   **If Local < Remote**: It prints a warning in the output:
        > "The Android plugin version is outdated. Current: [X] Latest: [Y]. Automatically update via: 'Tools -> AdMob Download Manager -> Android -> LatestVersion'"
4.  **Automatic Update**: The "LatestVersion" tool mentioned in the warning performs the same action as the **Automatic Installation** step (Download + Unzip).

### iOS Flow
The iOS setup requires manual intervention. The user is responsible for downloading and installing the necessary frameworks manually.

```mermaid
graph TD
    Start([Plugin Activation]) --> |Android Lifecycle| CheckAndroid{Check Exists:<br/>android/bin/package.gd}

    %% Android - Missing File (Auto Install)
    CheckAndroid -- No --> AutoInstall["<B>Auto Install</B><br/>Download & Unzip to:<br/>res://addons/admob/android/bin/"]
    AutoInstall --> Ready([Ready])

    %% Android - Existing File (Version Check)
    CheckAndroid -- Yes --> FetchRemote[Fetch Remote VERSION<br/>from godot-admob-versions]
    FetchRemote --> CompareVersions{Local < Remote?}

    %% Version Result
    CompareVersions -- Yes --> Warning["Print Warning:<br/>'Version is outdated...'"]
    Warning --> UserUpdate["User Action:<br/>Tools -> Download Manager<br/>(Trigger Auto Install)"]
    UserUpdate -.-> AutoInstall
    
    CompareVersions -- No --> Ready

    %% iOS
    Start -.->|iOS Lifecycle| ManualIOS[Manual Setup Required]
```
