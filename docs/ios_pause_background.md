# iOS Pause Background

This step is only for iOS, it will indicate if your Game in Godot should be paused or not when a full-screen ad is shown, such as Interstitial, Rewarded, and Rewarded Interstitial.

On Android, your game will be automatically paused when a full-screen ad is shown (Google doesn't allow it to configure). Calling this method passing a `true` parameter will duplicate this behavior on iOS.

On iOS, the default value is `false`.

# Prerequisites

- Complete the [Get started guide](README.md)
- Use Godot v4.1 or higher
- Use AdMob Plugin **[Editor](https://github.com/Poing-Studios/godot-admob-plugin/releases/tag/v3.1.0)** and **[iOS](https://github.com/Poing-Studios/godot-admob-ios/releases/tag/v3.1.0)**: v3.1.0+

# How to use
You can use this whenever you want this method, before, during, or after the initialization, such as:

```gdscript linenums="1" hl_lines="2"
func _on_set_ios_app_pause_on_background_button_pressed() -> void:
	MobileAds.set_ios_app_pause_on_background(true)
```

# Important notes

If your game is multiplayer, probably you will need this value as `false` due to connection issues. 
Read more about it here: https://github.com/Poing-Studios/godot-admob-ios/issues/70