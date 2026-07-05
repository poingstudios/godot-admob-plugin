# AdListener

The `AdListener` class allows you to listen to lifecycle events for banner ads loaded via [`AdView`](../classes/AdView.md) and native overlay ads loaded via [`NativeOverlayAd`](../classes/NativeOverlayAd.md).

## Properties

All properties are callable delegates (or action delegates in C#) that trigger when the respective ad event occurs:

### `on_ad_clicked` / `OnAdClicked`

Triggered when the user clicks the ad.

=== "GDScript"
    ```gdscript
    var on_ad_clicked: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClicked { get; set; }
    ```

### `on_ad_closed` / `OnAdClosed`

Triggered when the user closes the overlay of an ad or returns to the application.

=== "GDScript"
    ```gdscript
    var on_ad_closed: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClosed { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

Triggered when the ad fails to load. Receives a [`LoadAdError`](../classes/LoadAdError.md) detailing the error.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```

### `on_ad_impression` / `OnAdImpression`

Triggered when an ad impression is recorded.

=== "GDScript"
    ```gdscript
    var on_ad_impression: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdImpression { get; set; }
    ```

### `on_ad_loaded` / `OnAdLoaded`

Triggered when the ad is loaded successfully.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdLoaded { get; set; }
    ```

### `on_ad_opened` / `OnAdOpened`

Triggered when the ad opens a full-screen overlay overlaying the application.

=== "GDScript"
    ```gdscript
    var on_ad_opened: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdOpened { get; set; }
    ```
