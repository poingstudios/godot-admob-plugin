# Interstitial
Interstitial ads are expansive, full-screen advertisements that overlay an app's interface and persist until they are closed by the user. They are most effective when strategically placed during natural pauses in the app's execution, such as between levels of a game or immediately after the completion of a task.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/interstitial)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/interstitial)

## Prerequisites
- Complete the [Get started guide](../README.md)

## Always test with test ads

When developing and testing your Godot apps, it's crucial to use test ads rather than live production ads. Failure to do so can result in the suspension of your AdMob account.

The most straightforward method to load test ads is by utilizing our dedicated test ad unit ID for Android and iOS interstitial:

=== "Android"
    ```
    ca-app-pub-3940256099942544/1033173712
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/4411468910
    ```

This particular ad unit ID has been purposefully configured to deliver test ads for every request. You can safely employ it during your coding, testing, and debugging phases. However, remember to replace this test ad unit ID with your own when you are ready to publish your app.

For a more comprehensive understanding of how the Mobile Ads SDK's test ads function, please refer to our documentation on [Test Ads](../enable_test_ads.md).


## Interstitial example

The code sample below demonstrates how to utilize the Interstitial. In this example, you'll create an instance of an Interstitial, load an ad into it using an AdRequest, and enhance functionality by handling various life cycle events.


### Load an ad
To load an interstitial ad, utilize the `InterstitialAdLoader` class. Pass in an `InterstitialAdLoadCallback` to receive the loaded ad or any potential errors. It's worth noting that, similar to other format load callbacks, the `InterstitialAdLoadCallback` leverages `LoadAdError` to provide comprehensive error details.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
    
    func _ready() -> void:
        #The initializate needs to be done only once, ideally at app launch.
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	#free memory
    	if _interstitial_ad:
    		#always call this method on all AdFormats to free memory on Android/iOS
    		_interstitial_ad.destroy()
    		_interstitial_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/1033173712"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/4411468910"
    
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    	interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("interstitial ad loaded" + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    
    	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
    
        public override void _Ready()
        {
            //The initializate needs to be done only once, ideally at app launch.
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            //free memory
            if (_interstitialAd != null)
            {
                //always call this method on all AdFormats to free memory on Android/iOS
                _interstitialAd.Destroy();
                _interstitialAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/1033173712";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/4411468910";
    
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("interstitial ad loaded");
                    _interstitialAd = interstitialAd;
                }
            };
    
            new InterstitialAdLoader().Load(unitId, new AdRequest(), interstitialAdLoadCallback);
        }
    }
    ```

### Configure the FullScreenContentCallback
The `FullScreenContentCallback` manages events associated with the display of your `InterstitialAd`. Before presenting the `InterstitialAd`, ensure that you configure the callback:

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
    var _full_screen_content_callback := FullScreenContentCallback.new()
    
    func _ready() -> void:
    	#...
    	_full_screen_content_callback.on_ad_clicked = func() -> void:
    		print("on_ad_clicked")
    	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
    		print("on_ad_dismissed_full_screen_content")
    	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
    		print("on_ad_failed_to_show_full_screen_content")
    	_full_screen_content_callback.on_ad_impression = func() -> void:
    		print("on_ad_impression")
    	_full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
    		print("on_ad_showed_full_screen_content")
    
    func _on_load_pressed():
    	#...
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    
    	#...
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("interstitial ad loaded" + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    		_interstitial_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
        private FullScreenContentCallback _fullScreenContentCallback;
    
        public override void _Ready()
        {
            //...
            _fullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdClicked = () => GD.Print("on_ad_clicked"),
                OnAdDismissedFullScreenContent = () => GD.Print("on_ad_dismissed_full_screen_content"),
                OnAdFailedToShowFullScreenContent = (AdError adError) => GD.Print("on_ad_failed_to_show_full_screen_content"),
                OnAdImpression = () => GD.Print("on_ad_impression"),
                OnAdShowedFullScreenContent = () => GD.Print("on_ad_showed_full_screen_content")
            };
        }
    
        private void OnLoadPressed()
        {
            //...
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                //...
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("interstitial ad loaded");
                    _interstitialAd = interstitialAd;
                    _interstitialAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### Show the ad

Interstitial ads are ideally displayed during organic breaks in the app's progression. Examples include between game levels or after a user accomplishes a task. To present an interstitial ad, employ the `show()` function.


=== "GDScript"

    ```gdscript linenums="1" hl_lines="3"
    func _on_show_pressed():
    	if _interstitial_ad:
    		_interstitial_ad.show()
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="4"
    private void OnShowPressed()
    {
        if (_interstitialAd != null)
            _interstitialAd.Show();
    }
    ```

### Clean up memory

Upon completion of an `InterstitialAd`, it's important to invoke the `destroy()` function before releasing your reference to it:

=== "GDScript"

    ```gdscript 
    if _interstitial_ad:
    	_interstitial_ad.destroy()
    	_interstitial_ad = null
    ```

=== "C#"

    ```csharp
    if (_interstitialAd != null)
    {
        _interstitialAd.Destroy();
        _interstitialAd = null;
    }
    ```


This action signals to the plugin that the object is no longer in use and that the memory it occupies can be reclaimed. Neglecting to call this method can lead to memory leaks.

## Best Practices for Interstitial Ads

1. **Consider Relevance**:
    - Evaluate whether interstitial ads are suitable for your app.
    - Interstitial ads work best in apps with natural transition points, such as task completions or level advancements. Ensure these points align with the user's expectation for a break in the action.

2. **Pause App Activity**:
    - When displaying an interstitial ad, pause relevant app activities to allow the ad to use specific resources effectively.
    - For example, suspend audio output when displaying an interstitial ad to enhance the ad experience.

3. **Optimize Loading Time**:
    - Load interstitial ads in advance by calling `InterstitialAdLoader.new().load()` before invoking `show()`. This ensures that your app has a fully loaded interstitial ad ready when it's time to display one.

4. **Avoid Overloading with Ads**:
    - Refrain from inundating users with excessive interstitial ads.
    - An overly frequent ad display can hinder the user experience and reduce clickthrough rates. Strike a balance that allows users to enjoy your app without constant interruptions.

Remember that implementing interstitial ads should enhance, not detract from, the user experience in your app.

## Further References

### Samples
- [Sample Project](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): A Minimal Illustration of usage of all Ad Formats
