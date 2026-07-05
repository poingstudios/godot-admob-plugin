# OnInitializationCompleteListener

La clase `OnInitializationCompleteListener` se utiliza para escuchar el evento de finalización de la inicialización del SDK [`MobileAds`](../classes/MobileAds.md).

## Propiedades

### `on_initialization_complete` / `OnInitializationComplete`

Se activa cuando finaliza la inicialización del SDK de Mobile Ads. Recibe un objeto [`InitializationStatus`](../classes/InitializationStatus.md) que contiene los estados de disponibilidad de los adaptadores de mediación.

=== "GDScript"
    ```gdscript
    var on_initialization_complete: Callable # Receives InitializationStatus
    ```

=== "C#"
    ```csharp
    public Action<InitializationStatus> OnInitializationComplete { get; set; }
    ```
