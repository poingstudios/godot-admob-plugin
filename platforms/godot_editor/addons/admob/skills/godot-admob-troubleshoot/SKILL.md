---
name: godot-admob-troubleshoot
description: Provides instructions to diagnose ad loading errors, handle error codes, open the Ad Inspector, and resolve integration issues in GDScript and C#. Use when debugging ad loading issues.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Troubleshooting Guide

Assists with diagnosing and resolving integration issues, interpreting ad load errors, and debugging your Godot AdMob implementation.

## Common Error Codes

When an ad fails to load, `LoadAdError` returns one of the following error codes:

| Error Code | Constant Name | Description |
| :--- | :--- | :--- |
| **0** | `ERROR_CODE_INTERNAL_ERROR` | Something happened internally; for instance, an invalid response was received from the ad server. |
| **1** | `ERROR_CODE_INVALID_REQUEST` | The ad request was invalid; for instance, the ad unit ID was incorrect or not configured. |
| **2** | `ERROR_CODE_NETWORK_ERROR` | The ad request was unsuccessful due to network connectivity issues. |
| **3** | `ERROR_CODE_NO_FILL` | The ad request was successful, but no ad was returned due to lack of ad inventory. |

## Debugging Workflows

1.  **Check Ad Inspector**: Launch the Ad Inspector to check SDK status, adapter configurations, and test ad delivery.
2.  **Verify Test Unit IDs**: Verify that you are using Google's official test ad unit IDs during development.
3.  **Check logs**: Inspect your console logs or device logcat (`adb logcat`) to find detailed logs from the Google Mobile Ads SDK.

### Code Examples

=== "GDScript"

    ```gdscript
    # Handle load ad error callbacks
    listener.on_ad_failed_to_load = func(error: LoadAdError) -> void:
    	print("Ad load failed. Code: ", error.code, " Message: ", error.message)
    	
    # Launch inspector
    func open_diagnostics() -> void:
    	MobileAds.open_ad_inspector()
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api;

    // Handle load ad error callbacks
    var listener = new AdListener();
    listener.OnAdFailedToLoad = (error) => {
        GD.Print($"Ad load failed. Code: {error.Code} Message: {error.Message}");
    };

    public void OpenDiagnostics()
    {
        MobileAds.OpenAdInspector();
    }
    ```
