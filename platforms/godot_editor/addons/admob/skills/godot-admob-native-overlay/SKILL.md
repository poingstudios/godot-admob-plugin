---
name: godot-admob-native-overlay
description: Provides instructions to implement, load, show, and destroy Native Overlay ads (customized/native-looking Control node template overlays) in GDScript and C#. Use when integrating native overlay ads.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Native Overlay Ads

Assists with implementing Native Overlay ads (rendering Google AdMob assets directly inside custom layout templates using Control nodes) in Godot 4.x.

## Native Overlay Workflow

1.  **Define and Instantiate NativeAdLayout**: Select a layout template (`small` or `medium`) and configure the styles.
2.  **Instantiate NativeAdLoader**: Create the loader using your Ad Unit ID and layout.
3.  **Configure NativeAdLoadCallback**: Define success (`on_ad_loaded`) and failure callbacks.
4.  **Load the Ad**: Call `native_ad_loader.load()` passing an `AdRequest` and load callback.
5.  **Configure FullScreenContentCallback**: Connect events to handle ad dismissal or click.
6.  **Crucial: Destroy the Ad**: Call `native_ad.destroy()` inside `_exit_tree()` or when changing scenes to free native memory.

### Code Examples

=== "GDScript"

    ```gdscript
    var native_ad: NativeAd
    var native_loader: NativeAdLoader

    func load_native_ad() -> void:
    	var ad_unit_id := "ca-app-pub-3940256099942544/2247696110" # Test ID
    	
    	# Configure visual template layout
    	var layout := NativeAdLayout.new()
    	layout.template_type = NativeAdLayout.TemplateType.SMALL
    	
    	# Optional styling (custom colors/backgrounds)
    	# layout.style = ...
    	
    	native_loader = NativeAdLoader.new(ad_unit_id, layout)
    	
    	var callback := NativeAdLoadCallback.new()
    	callback.on_ad_loaded = func(ad: NativeAd) -> void:
    		native_ad = ad
    		print("Native ad loaded successfully.")
    		setup_native_callbacks()
    		
    	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
    		print("Native ad failed to load: ", error.message)
    		
    	native_loader.load(AdRequest.new(), callback)

    func setup_native_callbacks() -> void:
    	if not native_ad:
    		return
    	var callbacks := FullScreenContentCallback.new()
    	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
    		print("Native ad dismissed.")
    		native_ad.destroy()
    		native_ad = null
    		
    	native_ad.full_screen_content_callback = callbacks

    func _exit_tree() -> void:
    	if native_ad:
    		native_ad.destroy()
    		native_ad = null
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;

    private NativeAd _nativeAd;
    private NativeAdLoader _nativeLoader;

    public void LoadNativeAd()
    {
        string adUnitId = "ca-app-pub-3940256099942544/2247696110"; // Test ID
        
        var layout = new NativeAdLayout();
        layout.TemplateType = NativeAdLayout.TemplateTypeSmall;
        
        _nativeLoader = new NativeAdLoader(adUnitId, layout);
        
        var callback = new NativeAdLoadCallback();
        callback.OnAdLoaded = (NativeAd ad) => {
            _nativeAd = ad;
            GD.Print("Native ad loaded successfully.");
            SetupNativeCallbacks();
        };
        callback.OnAdFailedToLoad = (error) => {
            GD.Print($"Native ad failed to load: {error.Message}");
        };
        
        _nativeLoader.Load(new AdRequest(), callback);
    }

    private void SetupNativeCallbacks()
    {
        if (_nativeAd == null) return;
        
        var callbacks = new FullScreenContentCallback();
        callbacks.OnAdDismissedFullScreenContent = () => {
            GD.Print("Native ad dismissed.");
            _nativeAd.Destroy();
            _nativeAd = null;
        };
        
        _nativeAd.FullScreenContentCallback = callbacks;
    }

    public override void _ExitTree()
    {
        if (_nativeAd != null)
        {
            _nativeAd.Destroy();
            _nativeAd = null;
        }
    }
    ```
