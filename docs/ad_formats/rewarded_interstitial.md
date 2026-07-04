# Rewarded Interstitial Ads

!!! note "Godot 3 (v1) Documentation"
    This page is for **Godot 3.x**. For **Godot 4.2+**, see the [latest documentation](https://poingstudios.github.io/godot-admob-plugin/stable/).

Rewarded interstitial is a type of incentivized ad format that allows you to offer a reward for ads that appear automatically during natural app transitions. Unlike traditional rewarded ads, users aren't required to opt in to view a rewarded interstitial.

---

## Implementing Rewarded Interstitial Ads

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("rewarded_interstitial_ad_loaded", self, "_on_rewarded_interstitial_ad_loaded")
        MobileAds.connect("rewarded_interstitial_ad_failed_to_load", self, "_on_rewarded_interstitial_ad_failed_to_load")
        MobileAds.connect("rewarded_interstitial_ad_closed", self, "_on_rewarded_interstitial_ad_closed")
        MobileAds.connect("user_earned_rewarded", self, "_on_user_earned_rewarded")
        
        # Load the rewarded interstitial ad
        MobileAds.load_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_loaded() -> void:
        print("Rewarded Interstitial ad loaded!")
        MobileAds.show_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_failed_to_load(error_code: int) -> void:
        print("Rewarded Interstitial failed to load: ", error_code)

    func _on_rewarded_interstitial_ad_closed() -> void:
        print("Rewarded Interstitial closed.")
        # Reload next ad
        MobileAds.load_rewarded_interstitial()

    func _on_user_earned_rewarded(currency: String, amount: int) -> void:
        print("User rewarded! Type: ", currency, ", Amount: ", amount)
        # Grant reward to player here
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("rewarded_interstitial_ad_loaded", this, nameof(_on_rewarded_interstitial_ad_loaded));
        MobileAds.Connect("rewarded_interstitial_ad_failed_to_load", this, nameof(_on_rewarded_interstitial_ad_failed_to_load));
        MobileAds.Connect("rewarded_interstitial_ad_closed", this, nameof(_on_rewarded_interstitial_ad_closed));
        MobileAds.Connect("user_earned_rewarded", this, nameof(_on_user_earned_rewarded));
        
        MobileAds.Call("load_rewarded_interstitial");
    }

    private void _on_rewarded_interstitial_ad_loaded()
    {
        GD.Print("Rewarded Interstitial loaded!");
        MobileAds.Call("show_rewarded_interstitial");
    }

    private void _on_rewarded_interstitial_ad_failed_to_load(int errorCode)
    {
        GD.Print("Rewarded Interstitial failed to load: " + errorCode);
    }

    private void _on_rewarded_interstitial_ad_closed()
    {
        GD.Print("Rewarded Interstitial closed.");
        MobileAds.Call("load_rewarded_interstitial");
    }

    private void _on_user_earned_rewarded(string currency, int amount)
    {
        GD.Print("User rewarded: " + amount + " " + currency);
    }
    ```

---

## Verification

You can query if the rewarded interstitial ad is loaded before showing it:

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_rewarded_interstitial_loaded():
        MobileAds.show_rewarded_interstitial()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_rewarded_interstitial_loaded"))
    {
        MobileAds.Call("show_rewarded_interstitial");
    }
    ```
