# iOS Pause Background

!!! note "Godot 3 (v1) Documentation"
    This page is for **Godot 3.x**. For **Godot 4.2+**, see the [stable documentation](https://poingstudios.github.io/godot-admob-plugin/stable/).

This step is only for iOS. It indicates whether your Godot game should be paused when a full-screen ad (such as Interstitial, Rewarded, or Rewarded Interstitial) is active.

On Android, your game is automatically paused when a full-screen ad is shown (this is controlled by the OS and cannot be configured). Passing `true` to this method replicates this behavior on iOS. On iOS, the default value is `false`.

---

## Prerequisites

- Complete the [Get started guide](index.md)
- Use Godot v3.3 or higher.

---

## How to Use

You can call this method at any time:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.set_ios_app_pause_on_background(true)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Call("set_ios_app_pause_on_background", true);
    }
    ```
