---
name: godot-admob-app-open
description: Provides instructions to implement, load, show, and destroy App Open ads (shown on application startup or app resume) in GDScript and C#. Use when integrating App Open ads.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - App Open Ads

Assists with implementing App Open ads using the `AppOpenAdLoader` and `AppOpenAd` classes in Godot 4.x.

## App Open Ads Workflow

1.  **Instantiate AppOpenAdLoader**: Set up a loader instance.
2.  **Configure AppOpenAdLoadCallback**: Define success (`on_ad_loaded`) and failure callbacks.
3.  **Load the Ad**: Call `app_open_loader.load()` passing the Ad Unit ID, `AdRequest`, and load callback.
4.  **Handle Loaded Ad**: Save the loaded `AppOpenAd` instance.
5.  **Configure FullScreenContentCallback**: Connect events to destroy/cleanup the ad on dismissal.
6.  **Show the Ad**: Call `app_open_ad.show()` when the user launches or switches back to your game.
7.  **Crucial: Destroy the Ad**: Call `app_open_ad.destroy()` inside the dismissed or show failure callbacks to free native memory.

### Code Examples

=== "GDScript"

    ```gdscript
    var app_open_ad: AppOpenAd
    var app_open_loader := AppOpenAdLoader.new()

    func load_app_open_ad() -> void:
    	var ad_unit_id := "ca-app-pub-3940256099942544/9257395921" # Test ID
    	var callback := AppOpenAdLoadCallback.new()
    	
    	callback.on_ad_loaded = func(ad: AppOpenAd) -> void:
    		app_open_ad = ad
    		print("App Open ad loaded.")
    		setup_app_open_callbacks()
    		
    	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
    		print("App Open ad failed to load: ", error.message)
    		
    	app_open_loader.load(ad_unit_id, AdRequest.new(), callback)

    func setup_app_open_callbacks() -> void:
    	if not app_open_ad:
    		return
    	var callbacks := FullScreenContentCallback.new()
    	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
    		print("App Open ad dismissed.")
    		app_open_ad.destroy()
    		app_open_ad = null
    	callbacks.on_ad_failed_to_show_full_screen_content = func(error: AdError) -> void:
    		print("App Open ad failed to show: ", error.message)
    		app_open_ad.destroy()
    		app_open_ad = null
    		
    	app_open_ad.full_screen_content_callback = callbacks

    func show_app_open_ad() -> void:
    	if app_open_ad:
    		app_open_ad.show()
    	else:
    		print("App Open ad not loaded yet.")
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;

    private AppOpenAd _appOpenAd;
    private AppOpenAdLoader _appOpenLoader = new AppOpenAdLoader();

    public void LoadAppOpenAd()
    {
        string adUnitId = "ca-app-pub-3940256099942544/9257395921"; // Test ID
        var callback = new AppOpenAdLoadCallback();
        
        callback.OnAdLoaded = (AppOpenAd ad) => {
            _appOpenAd = ad;
            GD.Print("App Open ad loaded.");
            SetupAppOpenCallbacks();
        };
        callback.OnAdFailedToLoad = (error) => {
            GD.Print($"App Open ad failed to load: {error.Message}");
        };
        
        _appOpenLoader.Load(adUnitId, new AdRequest(), callback);
    }

    private void SetupAppOpenCallbacks()
    {
        if (_appOpenAd == null) return;
        
        var callbacks = new FullScreenContentCallback();
        callbacks.OnAdDismissedFullScreenContent = () => {
            GD.Print("App Open ad dismissed.");
            _appOpenAd.Destroy();
            _appOpenAd = null;
        };
        callbacks.OnAdFailedToShowFullScreenContent = (error) => {
            GD.Print($"App Open ad failed to show: {error.Message}");
            _appOpenAd.Destroy();
            _appOpenAd = null;
        };
        
        _appOpenAd.FullScreenContentCallback = callbacks;
    }

    public void ShowAppOpenAd()
    {
        if (_appOpenAd != null)
        {
            _appOpenAd.Show();
        }
    }
    ```
