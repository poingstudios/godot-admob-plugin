# OnInitializationCompleteListener

A classe `OnInitializationCompleteListener` é usada para ouvir o evento de conclusão da inicialização do SDK [`MobileAds`](../classes/MobileAds.md).

## Propriedades

### `on_initialization_complete` / `OnInitializationComplete`

Acionado quando a inicialização do SDK Mobile Ads termina. Recebe um objeto [`InitializationStatus`](../classes/InitializationStatus.md) contendo os estados de prontidão dos adaptadores de mediação.

=== "GDScript"
    ```gdscript
    var on_initialization_complete: Callable # Receives InitializationStatus
    ```

=== "C#"
    ```csharp
    public Action<InitializationStatus> OnInitializationComplete { get; set; }
    ```
