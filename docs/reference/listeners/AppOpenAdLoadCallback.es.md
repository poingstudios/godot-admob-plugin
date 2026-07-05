# AppOpenAdLoadCallback

La clase `AppOpenAdLoadCallback` se utiliza para escuchar el resultado de la carga de una solicitud de [`AppOpenAd`](../classes/AppOpenAd.md).

## Propiedades

### `on_ad_loaded` / `OnAdLoaded`

Se activa cuando el anuncio se carga correctamente. Recibe la instancia de [`AppOpenAd`](../classes/AppOpenAd.md) cargada.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives AppOpenAd
    ```

=== "C#"
    ```csharp
    public Action<AppOpenAd> OnAdLoaded { get; set; }
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
