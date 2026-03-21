# Volume Controls

Control the volume of AdMob video ads so you can integrate them with your app's audio settings. Volume controls work on both Android and iOS.

Use `set_app_volume()` to set the relative volume (0.0 to 1.0) and `set_app_muted()` to mute or unmute ad audio.

# Prerequisites

- Complete the [Get started guide](README.md)
- Use Godot v4.2 or higher

# How to use

=== "GDScript"

    ```gdscript
    # Set ad volume (0.0 = silent, 1.0 = full volume)
    MobileAds.set_app_volume(0.5)
    
    # Mute or unmute ads
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // Set ad volume (0.0 = silent, 1.0 = full volume)
    MobileAds.SetAppVolume(0.5f);
    
    // Mute or unmute ads
    MobileAds.SetAppMuted(true);
    ```

# API Reference

**set_app_volume(volume: float)**

Sets the relative volume for ad playback. Values are clamped to the range 0.0 (silent) to 1.0 (current device volume).

**set_app_muted(muted: bool)**

Informs the AdMob SDK when app audio is muted. When `true`, ad audio is muted.

# Important notes

- These settings apply to video ads (Interstitial, Rewarded, Rewarded Interstitial, App Open). Banner and native ads may not support custom volume control.
- Volume settings can be changed at any time, before or after ad loading.
- Synchronize these calls with your app's in-game volume slider or settings screen for a consistent user experience.
