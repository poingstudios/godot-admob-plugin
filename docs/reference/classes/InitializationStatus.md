# InitializationStatus

The `InitializationStatus` class contains initialization details for the Google Mobile Ads SDK and its configured mediation adapters.

## Properties

### `adapter_status_map` / `AdapterStatusMap`

A dictionary mapping adapter class names (as strings) to their respective `AdapterStatus`.

=== "GDScript"
    ```gdscript
    var adapter_status_map: Dictionary # Dictionary[String, AdapterStatus]
    ```

=== "C#"
    ```csharp
    public Dictionary<string, AdapterStatus> AdapterStatusMap { get; }
    ```
