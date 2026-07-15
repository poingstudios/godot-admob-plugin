---
name: godot-admob-banner
description: Provides instructions to implement, load, and destroy banner ads (AdView) using custom or adaptive sizes in GDScript and C#. Use when integrating banner ads.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Banner Ads

Assists with implementing, displaying, and destroying banner ads using the `AdView` and `AdSize` classes in Godot 4.x.

## Banner Ads Workflow

1.  **Define and Instantiate AdView**: Create an `AdView` with your Ad Unit ID, selected `AdSize`, and screen `AdPosition`.
2.  **Configure AdListener**: Set up an `AdListener` to respond to events such as `on_ad_loaded`, `on_ad_failed_to_load`, etc.
3.  **Load the Ad**: Call `ad_view.load_ad(AdRequest.new())`.
4.  **Crucial: Destroy the Ad**: Call `ad_view.destroy()` inside `_exit_tree()` or when changing scenes to free memory.

### Code Examples

=== "GDScript"

    ```gdscript
    var ad_view: AdView

    func load_banner_ad() -> void:
    	var ad_unit_id := "ca-app-pub-3940256099942544/6300978111" # Test ID
    	var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
    	var ad_position := AdPosition.BOTTOM
    	
    	ad_view = AdView.new(ad_unit_id, ad_size, ad_position)
    	
    	var listener := AdListener.new()
    	listener.on_ad_loaded = func() -> void:
    		print("Banner loaded successfully.")
    	listener.on_ad_failed_to_load = func(error: LoadAdError) -> void:
    		print("Banner failed to load: ", error.message)
    		
    	ad_view.ad_listener = listener
    	
    	# To request a collapsible banner:
    	# var request := AdRequest.new()
    	# request.extras = {"collapsible": "bottom"}
    	# ad_view.load_ad(request)
    	
    	ad_view.load_ad(AdRequest.new())

    func _exit_tree() -> void:
    	if ad_view:
    		ad_view.destroy()
    		ad_view = null
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;

    private AdView _adView;

    public void LoadBannerAd()
    {
        string adUnitId = "ca-app-pub-3940256099942544/6300978111"; // Test ID
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adPosition = AdPosition.Bottom;
        
        _adView = new AdView(adUnitId, adSize, adPosition);
        
        var listener = new AdListener();
        listener.OnAdLoaded = () => GD.Print("Banner loaded successfully.");
        listener.OnAdFailedToLoad = (error) => GD.Print($"Banner failed to load: {error.Message}");
        
        _adView.AdListener = listener;
        _adView.LoadAd(new AdRequest());
    }

    public override void _ExitTree()
    {
        if (_adView != null)
        {
            _adView.Destroy();
            _adView = null;
        }
    }
    ```
