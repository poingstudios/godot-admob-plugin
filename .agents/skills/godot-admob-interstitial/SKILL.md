---
name: godot-admob-interstitial
description: Provides instructions to implement, load, show, and destroy interstitial ads (full-screen image/text ads) in GDScript and C#. Use when integrating interstitial ads.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Interstitial Ads

Assists with implementing full-screen interstitial ads using the `InterstitialAdLoader` and `InterstitialAd` classes in Godot 4.x.

## Interstitial Ads Workflow

1.  **Instantiate InterstitialAdLoader**: Set up a loader instance.
2.  **Configure InterstitialAdLoadCallback**: Define success (`on_ad_loaded`) and failure callbacks.
3.  **Load the Ad**: Call `interstitial_ad_loader.load()` passing the Ad Unit ID, `AdRequest`, and load callback.
4.  **Handle Loaded Ad**: Save the loaded `InterstitialAd` instance in success callback.
5.  **Configure FullScreenContentCallback**: Listen to show, click, dismiss, and fail-to-show events.
6.  **Show the Ad**: Call `interstitial_ad.show()` to display the ad.
7.  **Crucial: Destroy the Ad**: Call `interstitial_ad.destroy()` inside the dismissed or show failure callback to free native memory.

### Code Examples

=== "GDScript"

    ```gdscript
    var interstitial_ad: InterstitialAd
    var interstitial_loader := InterstitialAdLoader.new()

    func load_interstitial() -> void:
    	var ad_unit_id := "ca-app-pub-3940256099942544/1033173712" # Test ID
    	var callback := InterstitialAdLoadCallback.new()
    	
    	callback.on_ad_loaded = func(ad: InterstitialAd) -> void:
    		interstitial_ad = ad
    		print("Interstitial loaded. Ready to show.")
    		setup_interstitial_callbacks()
    		
    	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
    		print("Interstitial failed to load: ", error.message)
    		
    	interstitial_loader.load(ad_unit_id, AdRequest.new(), callback)

    func setup_interstitial_callbacks() -> void:
    	if not interstitial_ad:
    		return
    	var callbacks := FullScreenContentCallback.new()
    	callbacks.on_ad_showed_full_screen_content = func() -> void:
    		print("Interstitial showed.")
    	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
    		print("Interstitial dismissed.")
    		interstitial_ad.destroy()
    		interstitial_ad = null
    	callbacks.on_ad_failed_to_show_full_screen_content = func(error: AdError) -> void:
    		print("Interstitial failed to show: ", error.message)
    		interstitial_ad.destroy()
    		interstitial_ad = null
    		
    	interstitial_ad.full_screen_content_callback = callbacks

    func show_interstitial() -> void:
    	if interstitial_ad:
    		interstitial_ad.show()
    	else:
    		print("Interstitial not loaded yet.")
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;

    private InterstitialAd _interstitialAd;
    private InterstitialAdLoader _interstitialLoader = new InterstitialAdLoader();

    public void LoadInterstitial()
    {
        string adUnitId = "ca-app-pub-3940256099942544/1033173712"; // Test ID
        var callback = new InterstitialAdLoadCallback();
        
        callback.OnAdLoaded = (InterstitialAd ad) => {
            _interstitialAd = ad;
            GD.Print("Interstitial loaded. Ready to show.");
            SetupInterstitialCallbacks();
        };
        callback.OnAdFailedToLoad = (error) => {
            GD.Print($"Interstitial failed to load: {error.Message}");
        };
        
        _interstitialLoader.Load(adUnitId, new AdRequest(), callback);
    }

    private void SetupInterstitialCallbacks()
    {
        if (_interstitialAd == null) return;
        
        var callbacks = new FullScreenContentCallback();
        callbacks.OnAdShowedFullScreenContent = () => GD.Print("Interstitial showed.");
        callbacks.OnAdDismissedFullScreenContent = () => {
            GD.Print("Interstitial dismissed.");
            _interstitialAd.Destroy();
            _interstitialAd = null;
        };
        callbacks.OnAdFailedToShowFullScreenContent = (error) => {
            GD.Print($"Interstitial failed to show: {error.Message}");
            _interstitialAd.Destroy();
            _interstitialAd = null;
        };
        
        _interstitialAd.FullScreenContentCallback = callbacks;
    }

    public void ShowInterstitial()
    {
        if (_interstitialAd != null)
        {
            _interstitialAd.Show();
        }
    }
    ```
