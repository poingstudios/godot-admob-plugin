# ResponseInfo

`ResponseInfo` 类包含已加载广告的元数据以及涉及中介请求链的适配器响应。

## 属性

### `loaded_adapter_response_info` / `LoadedAdapterResponseInfo`

成功加载广告的特定中介适配器的元数据，如果没有成功则为 `null`。

=== "GDScript"
    ```gdscript
    var loaded_adapter_response_info: AdapterResponseInfo
    ```

=== "C#"
    ```csharp
    public AdapterResponseInfo LoadedAdapterResponseInfo { get; set; }
    ```

### `adapter_responses` / `AdapterResponses`

中介瀑布流链中每个适配器的响应列表。

=== "GDScript"
    ```gdscript
    var adapter_responses: Array[AdapterResponseInfo]
    ```

=== "C#"
    ```csharp
    public List<AdapterResponseInfo> AdapterResponses { get; set; }
    ```

### `response_extras` / `ResponseExtras`

包含由广告服务器填充的元数据额外字段的字典。

=== "GDScript"
    ```gdscript
    var response_extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary ResponseExtras { get; set; }
    ```

### `mediation_adapter_class_name` / `MediationAdapterClassName`

加载广告的中介广告适配器的类名。

=== "GDScript"
    ```gdscript
    var mediation_adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string MediationAdapterClassName { get; set; }
    ```

### `response_id` / `ResponseId`

广告响应的唯一标识符。

=== "GDScript"
    ```gdscript
    var response_id: String
    ```

=== "C#"
    ```csharp
    public string ResponseId { get; set; }
    ```
