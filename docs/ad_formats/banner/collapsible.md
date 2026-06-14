# Collapsible Banner Ads

Collapsible banner ads are banner ads that are initially presented as a larger overlay, with a button to collapse them to the originally requested banner size. Collapsible banner ads are intended to improve performance of anchored ads that are otherwise a smaller size. This guide shows how to turn on collapsible banner ads for existing banner placements.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/banner/collapsible)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/banner/collapsible)

## Prerequisites
- Complete the [Banner Get Started guide](get_started.md).

## Implementation

Make sure your `AdView` is defined with the size you would like users to see in the regular (collapsed) banner state. Include an extras parameter in the `AdRequest` with `collapsible` as the key and the placement of the ad as the value.

The collapsible placement defines how the expanded region anchors to the banner ad.

| Placement value | Behavior | Intended use case |
|---|---|---|
| `top` | The top of the expanded ad aligns to the top of the collapsed ad. | The ad is placed at the top of the screen. |
| `bottom` | The bottom of the expanded ad aligns to the bottom of the collapsed ad. | The ad is placed at the bottom of the screen. |

If the loaded ad is a collapsible banner, the banner shows the collapsible overlay immediately once it's placed in the view hierarchy.

=== "GDScript"

    ```gdscript linenums="1" hl_lines="2"
    var ad_request := AdRequest.new()
    ad_request.extras["collapsible"] = "bottom"

    _ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="2"
    var adRequest = new AdRequest();
    adRequest.Extras["collapsible"] = "bottom";
    
    _adView.LoadAd(adRequest);
    ```

!!! info "Important"
    The collapsible banner feature is not available for large anchored adaptive banners. If your app requires collapsible functionality, use [standard anchored adaptive banners](sizes/anchored_adaptive.md).

## Ads refreshing behavior

For apps that configure auto-refresh for banner ads in the AdMob web interface, when a collapsible banner ad is requested for a banner slot, subsequent ad refreshes won't request collapsible banner ads. This is because showing a collapsible banner on every refresh could have a negative impact on user experience.

If you want to load another collapsible banner ad later in the session, you can load an ad manually with a request containing the `collapsible` parameter.

## Check if a loaded ad is collapsible

Non-collapsible banner ads are eligible to return for collapsible banner requests to maximize performance. Call `is_collapsible()` (or `IsCollapsible()` in C#) to check if the last banner loaded is collapsible.

=== "GDScript"
    ```gdscript linenums="1" hl_lines="6"
    func _ready() -> void:
    	# ...
    	_ad_view.ad_listener.on_ad_loaded = _on_ad_loaded

    func _on_ad_loaded() -> void:
    	var is_collapsible: bool = _ad_view.is_collapsible()
    	print("Ad loaded. Collapsible: %s" % is_collapsible)
    ```

=== "C#"
    ```csharp linenums="1" hl_lines="7"
    private void RegisterAdListener()
    {
    	_adView.AdListener = new AdListener
    	{
    		OnAdLoaded = () => 
    		{
    			bool isCollapsible = _adView.IsCollapsible();
    			GD.Print($"Ad loaded. Collapsible: {isCollapsible}");
    		}
    	};
    }
    ```

## Mediation

Collapsible banner ads are only available for Google demand. Ads served through mediation show as normal, non-collapsible banner ads.
