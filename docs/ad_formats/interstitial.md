# Interstitial Ads

!!! note "Godot 3 (v1) Documentation"
    This page is for **Godot 3.x**. For **Godot 4.2+**, see the [stable documentation](https://poingstudios.github.io/godot-admob-plugin/stable/).

Interstitial ads are full-screen ads that cover the interface of their host app. They're typically displayed at natural transition points in the flow of an app, such as between activities or during the pause between levels in a game.

---

## Implementing Interstitial Ads

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_failed_to_load", self, "_on_interstitial_failed_to_load")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        
        # Load the interstitial ad
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Interstitial loaded! Ready to show.")
        # Show interstitial immediately, or save it for later
        MobileAds.show_interstitial()

    func _on_interstitial_failed_to_load(error_code: int) -> void:
        print("Interstitial failed to load: ", error_code)

    func _on_interstitial_closed() -> void:
        print("Interstitial ad closed by the user.")
        # Load the next interstitial ad
        MobileAds.load_interstitial()
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_failed_to_load", this, nameof(_on_interstitial_failed_to_load));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Interstitial loaded!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_failed_to_load(int errorCode)
    {
        GD.Print("Interstitial failed to load: " + errorCode);
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Interstitial closed.");
        MobileAds.Call("load_interstitial");
    }
    ```

---

## Verification

You can query if the interstitial ad has completed loading before presenting it:

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_interstitial_loaded():
        MobileAds.show_interstitial()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_interstitial_loaded"))
    {
        MobileAds.Call("show_interstitial");
    }
    ```
