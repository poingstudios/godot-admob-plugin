# Preview Mock Ads in Editor

!!! note "Godot 3 (v1) Documentation"
    This page is for **Godot 3.x**. For **Godot 4.2+**, see the [latest documentation](https://poingstudios.github.io/godot-admob-plugin/stable/).

The plugin comes with a built-in Mock Ad system. This allows you to test your ad integration visual layouts and logic flow directly inside the Godot Editor without deploying to a physical device.

Mock ads simulate ad behaviors and fire the exact same lifecycle callbacks (such as load, show, clicks, and dismissals) as the real mobile SDKs.

---

## How it Works

The plugin automatically detects when your game is running on a desktop platform (Windows, macOS, or Linux) inside the Godot Editor. Instead of failing due to missing Android or iOS native singletons, the plugin instantiates mock singletons and nodes automatically.

You do not need to change any of your C# or GDScript code. All standard `MobileAds` singleton APIs function exactly the same way.

---

## Supported Formats

The mock system simulates the visual appearance and interactions for the following ad formats:

### Banners
- Renders a mock banner container on screen matching your configured position and size (Standard, Large, Medium Rectangle, or Leaderboard).
- Features a close button (`×`) to simulate dismissals.

### Interstitials
- Renders a full-screen interstitial overlay.
- Features a close button (`X`) that hides the ad and fires the `interstitial_closed` callback.

### Rewarded & Rewarded Interstitials
- Renders a full-screen rewarded video simulation.
- Plays a simulated video countdown timer.
- Automatically fires the `user_earned_rewarded` callback once the countdown completes.
- Displays a close button (`X`) to return to the game.

---

## Debugging Lifecycle Callbacks

The mock plugins trigger the exact same signals as the real mobile SDKs:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Ad loaded in Editor!")
        MobileAds.show_interstitial()

    func _on_interstitial_closed() -> void:
        print("Ad dismissed in Editor!")
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Ad loaded in Editor!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Ad dismissed in Editor!");
    }
    ```
