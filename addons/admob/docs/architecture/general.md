# Overview

The **Godot AdMob Editor Plugin** acts as a central hub for integrating Google AdMob into Godot projects. Instead of bundling large native libraries directly, it operates as a sophisticated **Download Manager** and **Configuration Tool**.

1.  **Dynamic Dependency Management**: The plugin connects to external repositories to fetch the correct version of native binaries (Android AARs and iOS Frameworks) compatible with the current plugin version.
2.  **Cross-Platform Abstraction**: It provides a unified GDScript API (`MobileAds`, `AdView`, etc.) that the developer uses.
3.  **Native Execution**: At runtime, this GDScript API communicates with the platform-specific "Bridges" (Java/Kotlin for Android, Objective-C/Swift for iOS), which in turn talk to the official Google Mobile Ads SDKs.

```mermaid
graph TD
    subgraph External [External Repositories]
        Versions[godot-admob-versions<br/>JSON Config]
        RepoAndroid[godot-admob-android<br/>Android Native Source]
        RepoiOS[godot-admob-ios<br/>iOS Native Source]
    end

    subgraph Editor [Godot Editor]
        UserLogic[User Game Logic<br/>GDScript]
        Plugin[AdMob Editor Plugin<br/>admob.gd]
    end

    subgraph Runtime_Android [Runtime: Android Device]
        AndroidBridge[Android Bridge<br/>.AAR Plugin]
        AndroidSDK[AdMob Android SDK]
    end

    subgraph Runtime_iOS [Runtime: iOS Device]
        iOSBridge[iOS Bridge<br/>.a framewok Plugin]
        iOSSDK[AdMob iOS SDK]
    end

    %% Editor Flow
    Plugin -- 1. Fetch Version Info --> Versions
    Plugin -- 2. Download .AAR --> RepoAndroid
    Plugin -- 2. Download .a framework --> RepoiOS
    
    %% Game Logic Flow
    UserLogic -- 3. Calls API --> Plugin
    
    %% Export/Runtime Flow
    Plugin -.->|Export| AndroidBridge
    Plugin -.->|Export| iOSBridge
    
    AndroidBridge -- 4. Calls --> AndroidSDK
    iOSBridge -- 4. Calls --> iOSSDK
```