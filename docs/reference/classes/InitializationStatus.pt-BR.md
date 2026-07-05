# InitializationStatus

A classe `InitializationStatus` contém detalhes de inicialização do SDK Google Mobile Ads e seus adaptadores de mediação configurados.

## Propriedades

### `adapter_status_map` / `AdapterStatusMap`

Um dicionário mapeando nomes de classes de adaptadores (como strings) para seus respectivos `AdapterStatus`.

=== "GDScript"
    ```gdscript
    var adapter_status_map: Dictionary # Dictionary[String, AdapterStatus]
    ```

=== "C#"
    ```csharp
    public Dictionary<string, AdapterStatus> AdapterStatusMap { get; }
    ```
