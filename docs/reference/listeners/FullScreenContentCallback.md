# FullScreenContentCallback

The `FullScreenContentCallback` class registers triggers for events related to showing full-screen ad formats (App Open, Interstitial, Rewarded, and Rewarded Interstitial).

## Properties

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

### `on_ad_dismissed_full_screen_content` / `OnAdDismissedFullScreenContent`

Triggered when the ad is closed/dismissed and the user returns to the application.

=== "GDScript"
    ```gdscript
    var on_ad_dismissed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdDismissedFullScreenContent { get; set; }
    ```

### `on_ad_failed_to_show_full_screen_content` / `OnAdFailedToShowFullScreenContent`

Triggered when the ad fails to present. Receives an `AdError` detailing the presentation error.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_show_full_screen_content: Callable # Receives AdError
    ```

=== "C#"
    ```csharp
    public Action<AdError> OnAdFailedToShowFullScreenContent { get; set; }
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

### `on_ad_showed_full_screen_content` / `OnAdShowedFullScreenContent`

Triggered when the ad is successfully presented on screen.

=== "GDScript"
    ```gdscript
    var on_ad_showed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdShowedFullScreenContent { get; set; }
    ```
