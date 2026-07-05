# ResponseInfo

The `ResponseInfo` class contains loaded ad metadata and adapter responses involved in the mediation request chain.

## Properties

### `loaded_adapter_response_info` / `LoadedAdapterResponseInfo`

The metadata for the specific mediation adapter that successfully loaded the ad, or `null` if none succeeded.

=== "GDScript"
    ```gdscript
    var loaded_adapter_response_info: AdapterResponseInfo
    ```

=== "C#"
    ```csharp
    public AdapterResponseInfo LoadedAdapterResponseInfo { get; set; }
    ```

### `adapter_responses` / `AdapterResponses`

A list of responses for each adapter in the mediation waterfall chain.

=== "GDScript"
    ```gdscript
    var adapter_responses: Array[AdapterResponseInfo]
    ```

=== "C#"
    ```csharp
    public List<AdapterResponseInfo> AdapterResponses { get; set; }
    ```

### `response_extras` / `ResponseExtras`

A dictionary containing metadata extra fields populated by the ad server.

=== "GDScript"
    ```gdscript
    var response_extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary ResponseExtras { get; set; }
    ```

### `mediation_adapter_class_name` / `MediationAdapterClassName`

The class name of the mediation ad adapter that loaded the ad.

=== "GDScript"
    ```gdscript
    var mediation_adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string MediationAdapterClassName { get; set; }
    ```

### `response_id` / `ResponseId`

A unique identifier for the ad response.

=== "GDScript"
    ```gdscript
    var response_id: String
    ```

=== "C#"
    ```csharp
    public string ResponseId { get; set; }
    ```
