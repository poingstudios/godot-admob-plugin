# Get Started
Banner ads are rectangular advertisements, consisting of either images or text, that are integrated into an app's layout. These ads remain on the screen while users engage with the app and can automatically refresh after a designated time interval. If you're new to mobile advertising, banner ads provide an excellent starting point for your ad implementation journey.

This guide demonstrates how to seamlessly integrate banner ads from AdMob into a Godot app. Alongside code snippets and detailed instructions, it also provides guidance on appropriately sizing banners and directs you to additional resources for further assistance.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/banner)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/banner)

## Prerequisites
- Complete the [Get started guide](../../README.md)

## Always test with test ads

When developing and testing your Godot apps, it's crucial to use test ads rather than live production ads. Failure to do so can result in the suspension of your AdMob account.

The most straightforward method to load test ads is by utilizing our dedicated test ad unit ID for Android and iOS banners:

=== "Android"
    ```
    ca-app-pub-3940256099942544/6300978111
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/2934735716
    ```

This particular ad unit ID has been purposefully configured to deliver test ads for every request. You can safely employ it during your coding, testing, and debugging phases. However, remember to replace this test ad unit ID with your own when you are ready to publish your app.

For a more comprehensive understanding of how the Mobile Ads SDK's test ads function, please refer to our documentation on [Test Ads](../../enable_test_ads.md).

## AdView example

The code sample below demonstrates how to utilize the AdView. In this example, you'll create an instance of an AdView, load an ad into it using an AdRequest, and enhance functionality by handling various life cycle events.


### Create a AdView (banner)
The initial step in utilizing a banner ad is to create an instance of an AdView within a GDScript attached to a Node.

```gdscript linenums="1" hl_lines="20"
extends Node2D

var _ad_view : AdView

func _ready():
	#The initializate needs to be done only once, ideally at app launch.
	MobileAds.initialize()

func _create_ad_view() -> void:
	#free memory
	if _ad_view:
		destroy_ad_view()

	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/6300978111"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/2934735716"

	_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.TOP)
```

The constructor for an AdView in Godot has the following parameters:

- `unit_id`: The AdMob ad unit ID from which the AdView should load ads.
- `AdSize`: The AdMob ad size you wish to utilize (refer to [AdView sizes](#adview-sizes) for specifics).
- `AdPosition`: The position at which the banner ad should be positioned. The `AdPosition.Values` enum enumerates the valid ad position values.

Take note of the distinct ad units used based on the platform. When making ad requests on iOS, you should utilize an iOS ad unit, while for Android, you must use an Android ad unit.

#### (Optional) Generate an AdView with a customized size
In addition to utilizing predefined AdSize constants, you can also specify a custom size for your ad:

```gdscript linenums="1"
var ad_size := AdSize.new(200, 200)
_ad_view := AdView.new(unit_id, ad_size, AdPosition.Values.TOP)
```

### Load a AdView (banner)
The second phase in utilizing the AdView involves crafting an AdRequest and then passing it to the `load_banner()` method.

```gdscript linenums="1" hl_lines="4 5"
func _on_load_banner_pressed():
	if _ad_view == null:
		_create_ad_view()
	var ad_request := AdRequest.new()
	_ad_view.load_ad(ad_request)
```


### Listen to AdView signals
To tailor the behavior of your ad, you can connect to various events in the ad's lifecycle, such as loading, opening, closing, and more. To monitor these events, you can register a `AdListener`:

```gdscript linenums="1" hl_lines="3 18"
func register_ad_listener() -> void:
	if _ad_view != null:
		var ad_listener := AdListener.new()
		
		ad_listener.on_ad_failed_to_load = func(load_ad_error : LoadAdError) -> void:
			print("_on_ad_failed_to_load: " + load_ad_error.message)
		ad_listener.on_ad_clicked = func() -> void:
			print("_on_ad_clicked")
		ad_listener.on_ad_closed = func() -> void:
			print("_on_ad_closed")
		ad_listener.on_ad_impression = func() -> void:
			print("_on_ad_impression")
		ad_listener.on_ad_loaded = func() -> void:
			print("_on_ad_loaded")
		ad_listener.on_ad_opened = func() -> void:
			print("_on_ad_opened")
			
		_ad_view.ad_listener = ad_listener
```

### Destroy the AdView (banner)
Upon completion of using the AdView, remember to call Destroy() to release allocated resources and free up memory.

```gdscript linenums="1" hl_lines="4"
func destroy_ad_view() -> void:
	if _ad_view:
		#always call this method on all AdFormats to free memory on Android/iOS
		_ad_view.destroy()
		_ad_view = null
```

That's all there is to it! Your app is now fully prepared to showcase banner ads from AdMob.

## AdView sizes

Below is a table presenting the standard banner ad sizes:


| Size in dp (WxH)                 | Description                                   | Availability       | AdSize constant  |
|----------------------------------|-----------------------------------------------|--------------------|------------------|
| 320x50                           | Standard Banner                               | Phones and Tablets | BANNER           |
| 320x100                          | Large Banner                                  | Phones and Tablets | LARGE_BANNER     |
| 300x250                          | IAB Medium Rectangle                          | Phones and Tablets | MEDIUM_RECTANGLE |
| 468x60                           | IAB Full-Size Banner                          | Tablets            | FULL_BANNER      |
| 728x90                           | IAB Leaderboard                               | Tablets            | LEADERBOARD      |
| Provided width x Adaptive height | [Adaptive banner](sizes/anchored_adaptive.md) | Phones and Tablets | N/A              |
| Screen width x 32/50/90          | [Smart banner](sizes/smart_banner.md)         | Phones and Tablets | N/A              |

## Further References

### Samples
- [Sample Project](https://github.com/Poing-Studios/godot-admob-plugin/tree/master/addons/admob/sample): A Minimal Illustration of usage of all Ad Formats


