# AppOpenAdLoadCallback

The `AppOpenAdLoadCallback` class is used to listen to the load outcome of an [`AppOpenAd`](../classes/AppOpenAd.md) load request.

## Properties

### `on_ad_loaded` / `OnAdLoaded`

Triggered when the ad is loaded successfully. Receives the loaded [`AppOpenAd`](../classes/AppOpenAd.md) instance.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives AppOpenAd
    ```

=== "C#"
    ```csharp
    public Action<AppOpenAd> OnAdLoaded { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

Triggered when the load request fails. Receives a [`LoadAdError`](../classes/LoadAdError.md) detailing the load error.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```
