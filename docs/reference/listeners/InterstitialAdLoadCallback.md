# InterstitialAdLoadCallback

The `InterstitialAdLoadCallback` class is used to listen to the load outcome of an `InterstitialAd` load request.

## Properties

### `on_ad_loaded` / `OnAdLoaded`

Triggered when the ad is loaded successfully. Receives the loaded `InterstitialAd` instance.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives InterstitialAd
    ```

=== "C#"
    ```csharp
    public Action<InterstitialAd> OnAdLoaded { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

Triggered when the load request fails. Receives a `LoadAdError` detailing the load error.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```
