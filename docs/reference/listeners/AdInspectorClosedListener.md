# AdInspectorClosedListener

The `AdInspectorClosedListener` class is used to listen to the closure event of the native Ad Inspector.

## Properties

### `on_ad_inspector_closed` / `OnAdInspectorClosed`

Triggered when the Ad Inspector is closed. Receives a dictionary detailing any error that occurred, or an empty dictionary if closed normally.

=== "GDScript"
    ```gdscript
    var on_ad_inspector_closed: Callable # Receives error: Dictionary
    ```

=== "C#"
    ```csharp
    public Action<Dictionary> OnAdInspectorClosed { get; set; }
    ```
