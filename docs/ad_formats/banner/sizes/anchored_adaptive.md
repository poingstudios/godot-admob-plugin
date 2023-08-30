# Anchored adaptive
Adaptive banners represent the evolution of responsive ads, enhancing performance by dynamically optimizing ad size for each device. Unlike smart banners, which supported only fixed heights, adaptive banners empower you to specify the ad's width, which is then used to determine the most suitable ad size.

To select the optimal ad size, adaptive banners rely on fixed aspect ratios instead of fixed heights. This results in banner ads that maintain a consistent proportion of the screen across various devices, offering the potential for improved performance.

When working with adaptive banners, it's important to note that they consistently return a set size for a particular device and width. Once you've tested your layout on a specific device, you can count on the ad size remaining unchanged. However, keep in mind that the banner creative's size may vary across different devices. Therefore, we recommend that your layout accommodates potential differences in ad height. In rare instances, the complete adaptive size may not be filled, and a standard-sized creative will be centered in that space instead.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/banner/anchored-adaptive)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/banner/anchored-adaptive)


## Prerequisites
- Complete the [Get started guide](../../../README.md)

## Implementation Notes for Adaptive Banners in Godot

1. **Width Knowledge**: You must have knowledge of the width of the view where the ad will be placed. **This should account for the device's width and any safe areas or cutouts that may be present**.

2. **Plugin Version**: Make sure you are using the latest version of the Google Mobile Ads Godot plugin. For mediation, ensure you are also using the latest version of each mediation adapter.

3. **Optimal Width Usage**: Adaptive banner sizes perform best when they utilize the full available width. In most cases, this equates to the full width of the device's screen. Take into account any safe areas that may apply.

4. **Ad Sizing**: The Google Mobile Ads SDK automatically sizes the banner with an optimized ad height based on the provided width when using the adaptive AdSize APIs.

5. **Adaptive Banner Sizes**: You can obtain adaptive ad sizes using three functions: `AdSize.get_landscape_anchored_adaptive_banner_ad_size` for landscape, `AdSize.get_portrait_anchored_adaptive_banner_ad_size` for portrait, and `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` for the current orientation at the time of execution.

6. **Stable Sizing**: The size returned for a given width on a specific device will remain constant. Therefore, once you've tested your layout on a particular device, you can be confident that the ad size will not change.

7. **Anchored Banner Height**: The anchored banner height is always within certain limits. It will never exceed 15% of the device's height or fall below 50 density-independent pixels (dp).

8. **Full Width Banners**: For full-width banners, you can use the `AdSize.FULL_WIDTH` constant instead of specifying a specific width.

## Quickstart Guide

Follow these steps to implement a simple adaptive anchor banner in Godot:

1. **Obtain Adaptive Ad Size**:
    - Get the width of the device in use in density-independent pixels (dp), or set your custom width if you don't want to use the full screen width. May `DisplayServer.window_get_size().x` be useful.
    - Alternatively, set a custom width if you don't wish to use the full screen width.
    - For full-width banners, use the `AdSize.FullWidth` flag.
    - Utilize the appropriate static methods on the ad size class, like `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)`, to obtain an adaptive `AdSize` object for the current orientation.

2. **Create a AdView**:
    - Instantiate a `AdView` object with your ad unit ID, the adaptive size obtained in step 1, and the desired position for your ad.

3. **Ad Request Creation**:
    - Create an ad request object.
    - Use the `load_ad()` function on your prepared ad view to load your adaptive anchor banner, just as you would with a standard banner request.

## Sample Code Illustration

Below is a script example that loads and refreshes an adaptive banner:
```gdscript linenums="1" hl_lines="25 29"
extends Node2D

var _ad_view : AdView
var _ad_listener := AdListener.new()

func _ready() -> void:
	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
	on_initialization_complete_listener.on_initialization_complete = func(initialization_status : InitializationStatus) -> void:
		_request_ad_view()
	MobileAds.initialize(on_initialization_complete_listener)
	
	_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
	_ad_listener.on_ad_loaded = _on_ad_loaded

func _request_ad_view() -> void:
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/6300978111"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/6300978111"
	
	if (_ad_view != null):
		_ad_view.destroy()
		
	var adaptive_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)	
	_ad_view = AdView.new(unit_id, adaptive_size, AdPosition.Values.TOP)
	_ad_view.ad_listener = _ad_listener
	
	_ad_view.load_ad(AdRequest.new())

func _on_ad_failed_to_load(load_ad_error : LoadAdError) -> void:
	print("_on_ad_failed_to_load: " + load_ad_error.message)

func _on_ad_loaded() -> void:
	print("_on_ad_loaded")

```

In this context, we use functions like `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` to retrieve the size for a banner in an anchored position, aligning with the current interface orientation. To pre-load an anchored banner for a specific orientation, you can make use of the appropriate function, either `AdSize.get_portrait_anchored_adaptive_banner_ad_size` or `AdSize.get_landscape_anchored_adaptive_banner_ad_size`.
