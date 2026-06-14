# Native Overlay Ads

Native Overlay ads are a specialized ad format that allows you to display a [Native Ad](https://support.google.com/admob/answer/6329630) on top of your app content. Unlike standard Native Ads that require you to build the UI yourself, Native Overlay ads use **Templates** to provide a consistent and easy-to-integrate experience, similar to other platforms.

!!! note
    This format is ideal for games and apps that want native look-and-feel without the complexity of manual UI layout.

## Prerequisites

Before you continue, do the following:

- Complete the [Get started guide](../README.md).

## Always test with test ads

The following table contains ad unit IDs which you can use to request test ads. They have been specially configured to return test ads rather than production ads for every request, making it safe to use.

However, after you've registered an app in the AdMob web interface and created your own ad unit IDs for use in your app, explicitly [configure your device as a test device](../enable_test_ads.md) during development.

=== "Android"

    ```
    ca-app-pub-3940256099942544/2247696110
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/3986624511
    ```

## Implementation

The main steps to integrate native overlay ads are:

1. Load the native ad
2. Define the template style
3. Render the template
4. Listen to ad events
5. Show/Hide or Destroy the ad

### Load the native ad

Loading a native ad is accomplished using the `load()` method on the `NativeOverlayAd` class. You need to provide an ad unit ID, an `AdRequest`, `NativeAdOptions`, and a completion callback.

=== "GDScript"

    ```gdscript linenums="1"
    var _native_overlay_ad: NativeOverlayAd

    # These ad units are configured to always serve test ads.
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/2247696110"
            return "ca-app-pub-3940256099942544/3986624511"

    func _load_native_ad() -> void:
        var ad_request := AdRequest.new()
        var options := NativeAdOptions.new()
        
        # Optional: configure options
        options.ad_choices_placement = AdChoicesPlacement.Values.TOP_RIGHT
        options.media_aspect_ratio = NativeMediaAspectRatio.Values.ANY

        NativeOverlayAd.load(_ad_unit_id, ad_request, options, _on_ad_load_finished)

    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        if error:
            print("Native ad failed to load: ", error.message)
            return
        
        print("Native ad loaded successfully")
        _native_overlay_ad = ad
        _render_native_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    private NativeOverlayAd _nativeOverlayAd;

    // These ad units are configured to always serve test ads.
    private string _adUnitId => OS.GetName() == "Android" 
        ? "ca-app-pub-3940256099942544/2247696110" 
        : "ca-app-pub-3940256099942544/3986624511";

    private void LoadNativeAd()
    {
        var adRequest = new AdRequest();
        var options = new NativeAdOptions();

        // Optional: configure options
        options.AdChoicesPlacement = AdChoicesPlacement.Values.TopRight;
        options.MediaAspectRatio = NativeMediaAspectRatio.Values.Any;

        NativeOverlayAd.Load(_adUnitId, adRequest, options, OnAdLoadFinished);
    }

    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        if (error != null)
        {
            GD.Print("Native ad failed to load: " + error.Message);
            return;
        }

        GD.Print("Native ad loaded successfully");
        _nativeOverlayAd = ad;
        RenderNativeAd();
    }
    ```

### Define the template style

You can use `NativeTemplateStyle` to customize how the ad looks. There are two main templates available: `SMALL` and `MEDIUM`.

=== "GDScript"

    ```gdscript linenums="1"
    func _render_native_ad() -> void:
        var style := NativeTemplateStyle.new()
        
        # Choose template: SMALL or MEDIUM
        style.template_id = NativeTemplateStyle.MEDIUM
        
        # Customize background color
        style.main_background_color = Color.WHITE
        
        # Customize Call To Action (CTA) button
        var cta_style := NativeTemplateTextStyle.new()
        cta_style.background_color = Color.DODGER_BLUE
        cta_style.text_color = Color.WHITE
        cta_style.font_size = 15.0
        cta_style.style = NativeTemplateFontStyle.Values.BOLD
        
        style.call_to_action_text = cta_style
        
        # Render the template at a specific position
        _native_overlay_ad.render_template(style, AdPosition.BOTTOM)
    ```

=== "C#"

    ```csharp linenums="1"
    private void RenderNativeAd()
    {
        var style = new NativeTemplateStyle();

        // Choose template: Small or Medium
        style.TemplateId = NativeTemplateStyle.Medium;

        // Customize background color
        style.MainBackgroundColor = Colors.White;

        // Customize Call To Action (CTA) button
        var ctaStyle = new NativeTemplateTextStyle();
        ctaStyle.BackgroundColor = Colors.DodgerBlue;
        ctaStyle.TextColor = Colors.White;
        ctaStyle.FontSize = 15.0f;
        ctaStyle.Style = NativeTemplateFontStyle.Bold;

        style.CallToActionText = ctaStyle;

        // Render the template at a specific position
        _nativeOverlayAd.RenderTemplate(style, AdPosition.Bottom);
    }
    ```

### Ad Positions

You can place the ad in several predefined positions or a custom XY coordinate using the `AdPosition` class.

- `AdPosition.TOP`
- `AdPosition.BOTTOM`
- `AdPosition.CENTER`
- `AdPosition.TOP_LEFT` / `AdPosition.TOP_RIGHT`
- `AdPosition.BOTTOM_LEFT` / `AdPosition.BOTTOM_RIGHT`
- `AdPosition.custom(x, y)`

### Listen to ad events

To handle user interactions, you can use the `ad_listener` property of the `NativeOverlayAd` instance.

=== "GDScript"

    ```gdscript linenums="1"
    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        # ... load check ...
        
        ad.ad_listener.on_ad_clicked = func(): print("Ad Clicked")
        ad.ad_listener.on_ad_impression = func(): print("Ad Impression")
        ad.ad_listener.on_ad_opened = func(): print("Ad Opened")
        ad.ad_listener.on_ad_closed = func(): print("Ad Closed")
    ```

=== "C#"

    ```csharp linenums="1"
    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        // ... load check ...

        ad.AdListener.OnAdClicked = () => GD.Print("Ad Clicked");
        ad.AdListener.OnAdImpression = () => GD.Print("Ad Impression");
        ad.AdListener.OnAdOpened = () => GD.Print("Ad Opened");
        ad.AdListener.OnAdClosed = () => GD.Print("Ad Closed");
    }
    ```

### Show/Hide and Destroy

Once rendered, you can control the visibility of the ad or destroy it completely to free resources.

=== "GDScript"

    ```gdscript linenums="1"
    # To hide the ad
    _native_overlay_ad.hide()

    # To show it again
    _native_overlay_ad.show()

    # To destroy it (required when finished)
    _native_overlay_ad.destroy()
    _native_overlay_ad = null
    ```

=== "C#"

    ```csharp linenums="1"
    // To hide the ad
    _nativeOverlayAd.Hide();

    // To show it again
    _nativeOverlayAd.Show();

    // To destroy it (required when finished)
    _nativeOverlayAd.Destroy();
    _nativeOverlayAd = null;
    ```

## Best practices

- **Destruction**: Always call `destroy()` when you no longer need the ad to prevent memory leaks on native platforms.
- **Background Loading**: You can load ads in the background and only call `render_template()` when you are ready to display them.
- **Template Choice**: Use `SMALL` templates for lists or tight spaces, and `MEDIUM` for more prominent placements like level transition screens.

## Additional resources

- [Sample Project](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): See the `Native` tab for a full implementation.
