# InitializationStatus

La clase `InitializationStatus` contiene detalles de inicialización del SDK de Google Mobile Ads y sus adaptadores de mediación configurados.

## Propiedades

### `adapter_status_map` / `AdapterStatusMap`

Un diccionario que asigna nombres de clases de adaptadores (como strings) a sus respectivos `AdapterStatus`.

=== "GDScript"
    ```gdscript
    var adapter_status_map: Dictionary # Dictionary[String, AdapterStatus]
    ```

=== "C#"
    ```csharp
    public Dictionary<string, AdapterStatus> AdapterStatusMap { get; }
    ```
