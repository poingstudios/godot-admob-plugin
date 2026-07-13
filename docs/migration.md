# Migrate SDK versions

This guide documents the API changes required when migrating your Godot project from v4 to v5 of the Godot AdMob Editor Plugin. 

v5 adopts the APIs of the new **GMA Next-Gen SDK** on Android. While the public API has been kept highly compatible to minimize migration effort, some legacy APIs have been removed.

---

## Smart Banner Removal

The legacy `Smart Banner` format has been deprecated by Google and is completely removed from the GMA Next-Gen SDK.

!!! danger "Breaking Change"
    The static property `AdSize.SMART_BANNER` (GDScript) and `AdSize.SmartBanner` (C#) have been completely removed. You must update your scripts to use adaptive size methods.

### How to Migrate
Use **Anchored Adaptive Banners** instead. They are the official modern replacement, dynamically calculating the optimal height based on the device width and screen density.

!!! note "Backward Compatibility Fallback"
    For safety, both the Android and iOS native plugins implement an automatic fallback: if an old scene or layout still sends a size of `-1` width and `-1` height, the native bridge intercepts it and returns a standard Anchored Adaptive Banner size matching the screen width.

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

---

## Gradle Dependency Changes

The native Android plugin now pulls the new Next-Gen SDK:

* **Old dependency:** `com.google.android.gms:play-services-ads`
* **New dependency:** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! info "Automatic Mediation Exclusions"
    To prevent duplicate symbols and conflicts when using Mediation Adapters (which might transitively pull the legacy SDK), the Godot export plugin automatically patches your Android export's `build.gradle` to exclude `play-services-ads` and `play-services-ads-lite`. No manual exclusion in your export configuration is required.
