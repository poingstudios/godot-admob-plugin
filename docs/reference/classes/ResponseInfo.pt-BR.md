# ResponseInfo

A classe `ResponseInfo` contém metadados de anúncio carregado e respostas de adaptadores envolvidos na cadeia de solicitação de mediação.

## Propriedades

### `loaded_adapter_response_info` / `LoadedAdapterResponseInfo`

Os metadados do adaptador de mediação específico que carregou o anúncio com sucesso, ou `null` se nenhum tiver sucesso.

=== "GDScript"
    ```gdscript
    var loaded_adapter_response_info: AdapterResponseInfo
    ```

=== "C#"
    ```csharp
    public AdapterResponseInfo LoadedAdapterResponseInfo { get; set; }
    ```

### `adapter_responses` / `AdapterResponses`

Uma lista de respostas para cada adaptador na cadeia de waterfall de mediação.

=== "GDScript"
    ```gdscript
    var adapter_responses: Array[AdapterResponseInfo]
    ```

=== "C#"
    ```csharp
    public List<AdapterResponseInfo> AdapterResponses { get; set; }
    ```

### `response_extras` / `ResponseExtras`

Um dicionário contendo campos extras de metadados preenchidos pelo servidor de anúncios.

=== "GDScript"
    ```gdscript
    var response_extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary ResponseExtras { get; set; }
    ```

### `mediation_adapter_class_name` / `MediationAdapterClassName` {: #mediation_adapter_class_name }

O nome da classe do adaptador de anúncio de mediação que carregou o anúncio.

=== "GDScript"
    ```gdscript
    var mediation_adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string MediationAdapterClassName { get; set; }
    ```

### `response_id` / `ResponseId`

Um identificador único para a resposta do anúncio.

=== "GDScript"
    ```gdscript
    var response_id: String
    ```

=== "C#"
    ```csharp
    public string ResponseId { get; set; }
    ```
