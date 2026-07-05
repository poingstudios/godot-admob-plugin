# AdapterStatus

A classe `AdapterStatus` representa o status de inicialização e as métricas de resposta de um adaptador de anúncio de mediação individual.

## Propriedades

### `latency` / `Latency`

A latência da inicialização do adaptador em milissegundos.

=== "GDScript"
    ```gdscript
    var latency: int
    ```

=== "C#"
    ```csharp
    public int Latency { get; set; }
    ```

### `initialization_state` / `State`

O estado de inicialização do adaptador.

=== "GDScript"
    ```gdscript
    var initialization_state: int # Matches values from InitializationState enum
    ```

=== "C#"
    ```csharp
    public InitializationState State { get; set; }
    ```

### `description` / `Description`

Uma descrição textual do status do adaptador ou descrição do erro de inicialização.

=== "GDScript"
    ```gdscript
    var description: String
    ```

=== "C#"
    ```csharp
    public string Description { get; set; }
    ```
