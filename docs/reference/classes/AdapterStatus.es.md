# AdapterStatus

La clase `AdapterStatus` representa el estado de inicialización y las métricas de respuesta de un adaptador de anuncios de mediación individual.

## Propiedades

### `latency` / `Latency`

La latencia de la inicialización del adaptador en milisegundos.

=== "GDScript"
    ```gdscript
    var latency: int
    ```

=== "C#"
    ```csharp
    public int Latency { get; set; }
    ```

### `initialization_state` / `State`

El estado de inicialización del adaptador.

=== "GDScript"
    ```gdscript
    var initialization_state: int # Matches values from InitializationState enum
    ```

=== "C#"
    ```csharp
    public InitializationState State { get; set; }
    ```

### `description` / `Description`

Una descripción textual del estado del adaptador o descripción del error de inicialización.

=== "GDScript"
    ```gdscript
    var description: String
    ```

=== "C#"
    ```csharp
    public string Description { get; set; }
    ```
