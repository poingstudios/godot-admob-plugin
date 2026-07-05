# AdListener

La clase `AdListener` le permite escuchar eventos del ciclo de vida de anuncios banner cargados a través de [`AdView`](../classes/AdView.md) y anuncios nativos superpuestos cargados a través de [`NativeOverlayAd`](../classes/NativeOverlayAd.md).

## Propiedades

Todas las propiedades son delegados invocables (o delegados Action en C#) que se activan cuando ocurre el respectivo evento de anuncio:

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

### `on_ad_closed` / `OnAdClosed`

Se activa cuando el usuario cierra la superposición de un anuncio o regresa a la aplicación.

=== "GDScript"
    ```gdscript
    var on_ad_closed: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClosed { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

Se activa cuando el anuncio falla al cargar. Recibe un [`LoadAdError`](../classes/LoadAdError.md) que detalla el error.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
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

### `on_ad_loaded` / `OnAdLoaded`

Se activa cuando el anuncio se carga correctamente.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdLoaded { get; set; }
    ```

### `on_ad_opened` / `OnAdOpened`

Se activa cuando el anuncio abre una superposición a pantalla completa sobre la aplicación.

=== "GDScript"
    ```gdscript
    var on_ad_opened: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdOpened { get; set; }
    ```
