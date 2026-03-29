# Smart Banner ⚠️ (deprecated)

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/banner/smart)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/banner/smart)


!!! note

    Try the newer [adaptive banners](anchored_adaptive.md) instead.

To use Smart Banners, use the `AdSize.SMART_BANNER` property (or `AdSize.SmartBanner` in C#) for the ad size when creating a AdView. For example:

=== "GDScript"

    ```gdscript linenums="1"
    # Create a Smart Banner at the top of the screen.
    var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    // Create a Smart Banner at the top of the screen.
    var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
    ```
