# Banner Ads

!!! note "Godot 3 (v1) Documentation"
    This page is for **Godot 3.x**. For **Godot 4.2+**, see the [stable documentation](https://poingstudios.github.io/godot-admob-plugin/stable/).

Banner ads occupy a spot within an app's layout, either at the top or bottom of the screen. They remain on screen while users are interacting with the app.

---

## Loading a Banner

To load a banner ad, call `MobileAds.load_banner()`. 

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("banner_loaded", self, "_on_banner_loaded")
        MobileAds.connect("banner_failed_to_load", self, "_on_banner_failed_to_load")
        
        # Loads a banner using your configured Banner Ad Unit ID
        MobileAds.load_banner()

    func _on_banner_loaded() -> void:
        print("Banner loaded successfully!")

    func _on_banner_failed_to_load(error_code: int) -> void:
        print("Banner failed to load with error code: ", error_code)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("banner_loaded", this, nameof(_on_banner_loaded));
        MobileAds.Connect("banner_failed_to_load", this, nameof(_on_banner_failed_to_load));
        
        MobileAds.Call("load_banner");
    }

    private void _on_banner_loaded()
    {
        GD.Print("Banner loaded successfully!");
    }

    private void _on_banner_failed_to_load(int errorCode)
    {
        GD.Print("Banner failed to load with error code: " + errorCode);
    }
    ```

---

## Displaying and Hiding Banners

If you configured the banner to not show instantly, you can control its visibility manually using the following methods:

=== "GDScript"

    ```gdscript
    # Show the loaded banner ad
    MobileAds.show_banner()

    # Hide the banner ad from the screen
    MobileAds.hide_banner()

    # Destroy the banner to release memory
    MobileAds.destroy_banner()
    ```

=== "C#"

    ```csharp
    // Show the loaded banner ad
    MobileAds.Call("show_banner");

    // Hide the banner ad from the screen
    MobileAds.Call("hide_banner");

    // Destroy the banner to release memory
    MobileAds.Call("destroy_banner");
    ```

---

## Checking Banner Dimensions

You can check the width and height of the banner using the helper methods:

=== "GDScript"

    ```gdscript
    var width = MobileAds.get_banner_width()
    var height = MobileAds.get_banner_height()
    var width_px = MobileAds.get_banner_width_in_pixels()
    var height_px = MobileAds.get_banner_height_in_pixels()
    ```

=== "C#"

    ```csharp
    // Use Convert.ToInt32 to safely fetch sizes on iOS/Android Mono:
    int width = System.Convert.ToInt32(MobileAds.Call("get_banner_width"));
    int height = System.Convert.ToInt32(MobileAds.Call("get_banner_height"));
    ```
