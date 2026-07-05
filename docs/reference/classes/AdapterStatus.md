# AdapterStatus

The `AdapterStatus` class represents the initialization status and response metrics of an individual mediation ad adapter.

## Properties

### `latency` / `Latency`

The latency of the adapter initialization in milliseconds.

=== "GDScript"
    ```gdscript
    var latency: int
    ```

=== "C#"
    ```csharp
    public int Latency { get; set; }
    ```

### `initialization_state` / `State`

The initialization state of the adapter.

=== "GDScript"
    ```gdscript
    var initialization_state: int # Matches values from InitializationState enum
    ```

=== "C#"
    ```csharp
    public InitializationState State { get; set; }
    ```

### `description` / `Description`

A textual description of the adapter's status or initialization error description.

=== "GDScript"
    ```gdscript
    var description: String
    ```

=== "C#"
    ```csharp
    public string Description { get; set; }
    ```
