---
name: godot-admob-mediation
description: Provides instructions to configure, integrate, and verify third-party mediation networks (AppLovin, Meta Audience Network, Unity Ads, etc.) in GDScript and C#. Use when setting up mediation adapters.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Mediation Integration

Assists with configuring and integrating third-party ad networks (mediation) with the Godot AdMob Editor Plugin.

## Mediation Workflow

1.  **Select Mediation Partners**: Enable required partner adapters (e.g. AppLovin, ironSource, Unity Ads) in your Godot Project Settings under **Admob > Mediation**.
2.  **Add Native Libraries**:
    *   **Android**: Check that the required AAR dependencies are configured in your custom build template.
    *   **iOS**: Check that the SPM/CocoaPods dependencies for the selected adapters are declared in the plugin configuration.
3.  **Verify Adapter Integration**: Launch the Ad Inspector to verify that all adapter connections are set up and functioning correctly.

### Code Examples

=== "GDScript"

    ```gdscript
    func open_inspector() -> void:
    	# Open the Mobile Ads Ad Inspector to check adapter status
    	MobileAds.open_ad_inspector()
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;

    public void OpenInspector()
    {
        // Open the Mobile Ads Ad Inspector to check adapter status
        MobileAds.OpenAdInspector();
    }
    ```
