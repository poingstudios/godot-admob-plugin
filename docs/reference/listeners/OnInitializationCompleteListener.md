# OnInitializationCompleteListener

The `OnInitializationCompleteListener` class is used to listen to the completion event of the `MobileAds` SDK initialization.

## Properties

### `on_initialization_complete` / `OnInitializationComplete`

Triggered when the Mobile Ads SDK initialization finishes. Receives an `InitializationStatus` object containing mediation adapter readiness states.

=== "GDScript"
    ```gdscript
    var on_initialization_complete: Callable # Receives InitializationStatus
    ```

=== "C#"
    ```csharp
    public Action<InitializationStatus> OnInitializationComplete { get; set; }
    ```
