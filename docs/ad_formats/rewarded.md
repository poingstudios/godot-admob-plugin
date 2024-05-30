# Rewarded

Rewarded video ads are immersive, full-screen video advertisements that provide users with the choice to watch them entirely. In return for their time and attention, users receive in-app rewards or benefits.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/rewarded)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/rewarded)

## Prerequisites
- Complete the [Get started guide](../README.md)


## Always test with test ads

When developing and testing your Godot apps, it's crucial to use test ads rather than live production ads. Failure to do so can result in the suspension of your AdMob account.

The most straightforward method to load test ads is by utilizing our dedicated test ad unit ID for Android and iOS rewarded:

=== "Android"
    ```
    ca-app-pub-3940256099942544/5224354917
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/1712485313
    ```

This particular ad unit ID has been purposefully configured to deliver test ads for every request. You can safely employ it during your coding, testing, and debugging phases. However, remember to replace this test ad unit ID with your own when you are ready to publish your app.

For a more comprehensive understanding of how the Mobile Ads SDK's test ads function, please refer to our documentation on [Test Ads](../enable_test_ads.md).


## Rewarded example

The code sample below demonstrates how to utilize the Rewarded. In this example, you'll create an instance of an Rewarded, load an ad into it using an AdRequest, and enhance functionality by handling various life cycle events.


### Load an ad
To load an rewarded ad, utilize the `RewardedAdLoader` class. Pass in an `RewardedAdLoadCallback` to receive the loaded ad or any potential errors. It's worth noting that, similar to other format load callbacks, the `RewardedAdLoadCallback` leverages `LoadAdError` to provide comprehensive error details.

```gdscript linenums="1" hl_lines="30"
extends Node2D

var _rewarded_ad : RewardedAd

func _ready() -> void:
    #The initializate needs to be done only once, ideally at app launch.
	MobileAds.initialize()

func _on_load_pressed():
	#free memory
	if _rewarded_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		_rewarded_ad.destroy()
		_rewarded_ad = null

	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/5224354917"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/1712485313"

	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)

	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
		print("rewarded ad loaded" + str(rewarded_ad._uid))
		_rewarded_ad = rewarded_ad

	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
```

### [Optional] Validate server-side verification (SSV) callbacks
For apps that necessitate additional data in server-side verification [Android](https://developers.google.com/admob/android/ssv)/[iOS](https://developers.google.com/admob/ios/ssv) callbacks, the custom data feature of rewarded ads can be employed. Any string value assigned to a rewarded ad object is transmitted to the `custom_data` query parameter of the SSV callback. If no custom data is set, the `custom_data` query parameter will be absent in the SSV callback.

The following code snippet illustrates how to establish custom data on a rewarded ad object before soliciting an ad:

```gdscript linenums="1" hl_lines="4 5 6 7"
rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
    print("rewarded ad loaded" + str(rewarded_ad._uid))
    
    var server_side_verification_options := ServerSideVerificationOptions.new()
    server_side_verification_options.custom_data = "TEST PURPOSE"
    server_side_verification_options.user_id = "user_id_test"
    rewarded_ad.set_server_side_verification_options(server_side_verification_options)
    
    _rewarded_ad = rewarded_ad
```
!!! note

    The custom reward string is [percent escaped](https://en.wikipedia.org/wiki/Percent-encoding) and might require decoding when parsed from the SSV callback.

### Configure the FullScreenContentCallback
The `FullScreenContentCallback` manages events associated with the display of your `RewardedAd`. Before presenting the `RewardedAd`, ensure that you configure the callback:

```gdscript linenums="1" hl_lines="28"
extends Node2D

var _rewarded_ad : RewardedAd
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
	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()

	#...

	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
		print("rewarded ad loaded" + str(rewarded_ad._uid))
		_rewarded_ad = rewarded_ad
		_rewarded_ad.full_screen_content_callback = _full_screen_content_callback

	#...


```

### Show the ad

When presenting a rewarded ad, you'll employ an `OnUserEarnedRewardListener` object to manage reward-related events.

```gdscript linenums="1" hl_lines="14"
extends Node2D

var _rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

func _ready() -> void:
	#...
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)

#...
func _on_show_pressed():
	if _rewarded_ad:
		_rewarded_ad.show(on_user_earned_reward_listener)
```

### Clean up memory

Upon completion of an `RewardedAd`, it's important to invoke the `destroy()` function before releasing your reference to it:

```gdscript 
if _rewarded_ad:
    _rewarded_ad.destroy()
    _rewarded_ad = null
```


This action signals to the plugin that the object is no longer in use and that the memory it occupies can be reclaimed. Neglecting to call this method can lead to memory leaks.

## Further References

### Samples
- [Sample Project](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): A Minimal Illustration of usage of all Ad Formats
