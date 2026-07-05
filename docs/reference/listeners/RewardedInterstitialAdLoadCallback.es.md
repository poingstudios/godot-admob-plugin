# RewardedInterstitialAdLoadCallback

La clase `RewardedInterstitialAdLoadCallback` se utiliza para escuchar el resultado de la carga de una solicitud de [`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md).

## Propiedades

### `on_ad_loaded` / `OnAdLoaded`

Se activa cuando el anuncio se carga correctamente. Recibe la instancia de [`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md) cargada.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives RewardedInterstitialAd
    ```

=== "C#"
    ```csharp
    public Action<RewardedInterstitialAd> OnAdLoaded { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

Se activa cuando la solicitud de carga falla. Recibe un [`LoadAdError`](../classes/LoadAdError.md) que detalla el error de carga.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```
