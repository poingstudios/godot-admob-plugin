# ResponseInfo

La clase `ResponseInfo` contiene metadatos del anuncio cargado y las respuestas de los adaptadores involucrados en la cadena de solicitud de mediación.

## Propiedades

### `loaded_adapter_response_info` / `LoadedAdapterResponseInfo`

Los metadatos del adaptador de mediación específico que cargó el anuncio con éxito, o `null` si ninguno tuvo éxito.

=== "GDScript"
    ```gdscript
    var loaded_adapter_response_info: AdapterResponseInfo
    ```

=== "C#"
    ```csharp
    public AdapterResponseInfo LoadedAdapterResponseInfo { get; set; }
    ```

### `adapter_responses` / `AdapterResponses`

Una lista de respuestas para cada adaptador en la cadena de waterfall de mediación.

=== "GDScript"
    ```gdscript
    var adapter_responses: Array[AdapterResponseInfo]
    ```

=== "C#"
    ```csharp
    public List<AdapterResponseInfo> AdapterResponses { get; set; }
    ```

### `response_extras` / `ResponseExtras`

Un diccionario que contiene campos extras de metadatos poblados por el servidor de anuncios.

=== "GDScript"
    ```gdscript
    var response_extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary ResponseExtras { get; set; }
    ```

### `mediation_adapter_class_name` / `MediationAdapterClassName` {: #mediation_adapter_class_name }

El nombre de la clase del adaptador de anuncio de mediación que cargó el anuncio.

=== "GDScript"
    ```gdscript
    var mediation_adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string MediationAdapterClassName { get; set; }
    ```

### `response_id` / `ResponseId`

Un identificador único para la respuesta del anuncio.

=== "GDScript"
    ```gdscript
    var response_id: String
    ```

=== "C#"
    ```csharp
    public string ResponseId { get; set; }
    ```
