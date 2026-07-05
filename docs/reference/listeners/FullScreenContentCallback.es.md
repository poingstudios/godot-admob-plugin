# FullScreenContentCallback

La clase `FullScreenContentCallback` registra disparadores para eventos relacionados con la visualización de formatos de anuncios a pantalla completa ([App Open](../classes/AppOpenAd.md), [Interstitial](../classes/InterstitialAd.md), [Rewarded](../classes/RewardedAd.md) y [Rewarded Interstitial](../classes/RewardedInterstitialAd.md)).

## Propiedades

### `on_ad_clicked` / `OnAdClicked`

Se activa cuando el usuario hace clic en el anuncio.

=== "GDScript"
    ```gdscript
    var on_ad_clicked: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClicked { get; set; }
    ```

### `on_ad_dismissed_full_screen_content` / `OnAdDismissedFullScreenContent`

Se activa cuando el anuncio se cierra/descarta y el usuario regresa a la aplicación.

=== "GDScript"
    ```gdscript
    var on_ad_dismissed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdDismissedFullScreenContent { get; set; }
    ```

### `on_ad_failed_to_show_full_screen_content` / `OnAdFailedToShowFullScreenContent`

Se activa cuando el anuncio falla al presentarse. Recibe un [`AdError`](../classes/AdError.md) que detalla el error de presentación.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_show_full_screen_content: Callable # Receives AdError
    ```

=== "C#"
    ```csharp
    public Action<AdError> OnAdFailedToShowFullScreenContent { get; set; }
    ```

### `on_ad_impression` / `OnAdImpression`

Se activa cuando se registra una impresión de anuncio.

=== "GDScript"
    ```gdscript
    var on_ad_impression: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdImpression { get; set; }
    ```

### `on_ad_showed_full_screen_content` / `OnAdShowedFullScreenContent`

Se activa cuando el anuncio se presenta correctamente en pantalla.

=== "GDScript"
    ```gdscript
    var on_ad_showed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdShowedFullScreenContent { get; set; }
    ```
