# Rewarded interstitial

A [Rewarded Interstitial](https://support.google.com/admob/answer/9884467) is a specific form of incentivized ad format that allows you to provide rewards in exchange for ads that appear automatically during natural app transitions. Unlike regular rewarded ads, users are not obligated to actively opt in to view a Rewarded Interstitial; they are seamlessly integrated into the app experience.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/rewarded-interstitial)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/rewarded-interstitial)

## Prerequisites
- Complete the [Get started guide](../README.md)


## Always test with test ads

When developing and testing your Godot apps, it's crucial to use test ads rather than live production ads. Failure to do so can result in the suspension of your AdMob account.

The most straightforward method to load test ads is by utilizing our dedicated test ad unit ID for Android and iOS rewarded interstitial:

=== "Android"
    ```
    ca-app-pub-3940256099942544/5354046379
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/6978759866
    ```

This particular ad unit ID has been purposefully configured to deliver test ads for every request. You can safely employ it during your coding, testing, and debugging phases. However, remember to replace this test ad unit ID with your own when you are ready to publish your app.

For a more comprehensive understanding of how the Mobile Ads SDK's test ads function, please refer to our documentation on [Test Ads](../enable_test_ads.md).

## Rewarded interstitial example

The code sample below demonstrates how to utilize the Rewarded interstitial. In this example, you'll create an instance of an Rewarded interstitial, load an ad into it using an AdRequest, and enhance functionality by handling various life cycle events.


### Load an ad
To load an rewarded interstitial ad, utilize the `RewardedInterstitialAdLoader` class. Pass in an `RewardedInterstitialAdLoadCallback` to receive the loaded ad or any potential errors. It's worth noting that, similar to other format load callbacks, the `RewardedInterstitialAdLoadCallback` leverages `LoadAdError` to provide comprehensive error details.

```gdscript linenums="1" hl_lines="30"
extends Node2D

var _rewarded_interstitial_ad : RewardedInterstitialAd

func _ready() -> void:
	#The initializate needs to be done only once, ideally at app launch.
	MobileAds.initialize()

func _on_load_pressed():
	#free memory
	if _rewarded_interstitial_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		_rewarded_interstitial_ad.destroy()
		_rewarded_interstitial_ad = null

	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/5354046379"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/6978759866"

	var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)

	rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
		print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
		_rewarded_interstitial_ad = rewarded_interstitial_ad

	RewardedInterstitialAdLoader.new().load(unit_id, AdRequest.new(), rewarded_interstitial_ad_load_callback)
```


### [Optional] Validate server-side verification (SSV) callbacks
For apps that necessitate additional data in server-side verification [Android](https://developers.google.com/admob/android/ssv)/[iOS](https://developers.google.com/admob/ios/ssv) callbacks, the custom data feature of rewarded ads can be employed. Any string value assigned to a rewarded ad object is transmitted to the `custom_data` query parameter of the SSV callback. If no custom data is set, the `custom_data` query parameter will be absent in the SSV callback.

The following code snippet illustrates how to establish custom data on a rewarded interstitial ad object before soliciting an ad:

```gdscript linenums="1" hl_lines="4 5 6 7"
rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
    print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))

    var server_side_verification_options := ServerSideVerificationOptions.new()
    server_side_verification_options.custom_data = "TEST PURPOSE"
    server_side_verification_options.user_id = "user_id_test"
    rewarded_interstitial_ad.set_server_side_verification_options(server_side_verification_options)

    _rewarded_interstitial_ad = rewarded_interstitial_ad
```
!!! note

    The custom reward string is [percent escaped](https://en.wikipedia.org/wiki/Percent-encoding) and might require decoding when parsed from the SSV callback.

### Configure the FullScreenContentCallback
The `FullScreenContentCallback` manages events associated with the display of your `RewardedInterstitialAd`. Before presenting the `RewardedInterstitialAd`, ensure that you configure the callback:

```gdscript linenums="1" hl_lines="28"
extends Node2D

var _rewarded_interstitial_ad : RewardedInterstitialAd
var _full_screen_content_callback : FullScreenContentCallback

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
	var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()

	#...

	rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
		print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
		_rewarded_interstitial_ad = rewarded_interstitial_ad
		_rewarded_interstitial_ad.full_screen_content_callback = _full_screen_content_callback

	#...

```

### Show the ad

When presenting a rewarded interstitial ad, you'll employ an `OnUserEarnedRewardListener` object to manage reward-related events.

```gdscript linenums="1" hl_lines="14"
extends Node2D

var _rewarded_interstitial_ad : RewardedInterstitialAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

func _ready() -> void:
	#...
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)

#...
func _on_show_pressed():
	if _rewarded_interstitial_ad:
		_rewarded_interstitial_ad.show(on_user_earned_reward_listener)
```

### Clean up memory

Upon completion of an `RewardedInterstitialAd`, it's important to invoke the `destroy()` function before releasing your reference to it:

```gdscript linenums="1"
if _rewarded_interstitial_ad:
    _rewarded_interstitial_ad.destroy()
    _rewarded_interstitial_ad = null
```


This action signals to the plugin that the object is no longer in use and that the memory it occupies can be reclaimed. Neglecting to call this method can lead to memory leaks.

## Further References

### Samples
- [Sample Project](https://github.com/Poing-Studios/godot-admob-plugin/tree/master/addons/admob/sample): A Minimal Illustration of usage of all Ad Formats
