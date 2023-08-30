# Smart Banner ⚠️ (deprecated)

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/banner/smart)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/banner/smart)


!!! note

    Try the newer [adaptive banners](anchored_adaptive.md) instead.

To use Smart Banners, use the `AdSize.get_smart_banner_ad_size()` function for the ad size when creating a AdView. For example:

```gdscript linenums="1"
# Create a Smart Banner at the top of the screen.
var ad_view := AdView.new(unit_id, AdSize.get_smart_banner_ad_size(), AdPosition.Values.TOP)
```
