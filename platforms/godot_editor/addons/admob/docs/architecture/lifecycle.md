# Plugin Lifecycle

This document outlines the lifecycle of the plugin upon activation, specifically regarding dependency management for Android and iOS.

## Activation & Dependency Checks

When the plugin is activated, it executes a pipeline to verify the integrity and version of its native dependencies. The process is self-healing and semi-automated for both platforms.

### Common Flow

1.  **Platform Identification**: The plugin first identifies the target platform (Android or iOS).
2.  **File Existence Verification**: It checks for the existence of a platform-specific package file:
	*   **Android**: `res://addons/admob/android/bin/package.gd`
	*   **iOS**: `res://addons/admob/ios/bin/package.gd`
3.  **Automatic Installation**: If the platform-specific package file is **missing**, the plugin automatically:
	*   Downloads the relevant platform binaries.
	*   Unzips them into the appropriate plugin directory (`res://addons/admob/android/bin/` for Android, `res://addons/admob/ios/bin/` for iOS).

```mermaid
graph TD
	Start([Plugin Activation]) --> IdentifyPlatform{Identify Platform}

	IdentifyPlatform -- Android --> CheckAndroid{Check Exists:<br/>res://addons/admob/android/bin/package.gd}
	IdentifyPlatform -- iOS --> CheckIOS{Check Exists:<br/>res://addons/admob/ios/bin/package.gd}

	CheckAndroid -- Yes --> Ready([Ready])
	CheckAndroid -- No --> AutoInstallAndroid[Auto Install to:<br/>res://addons/admob/android/bin/] --> Ready
	
	CheckIOS -- Yes --> Ready
	CheckIOS -- No --> AutoInstallIOS[Auto Install to:<br/>res://addons/admob/ios/bin/] --> Ready
```
