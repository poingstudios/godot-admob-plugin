# InitializationStatus

`InitializationStatus` 类包含 Google Mobile Ads SDK 及其配置的 mediation 适配器的初始化详细信息。

## 属性

### `adapter_status_map` / `AdapterStatusMap`

将适配器类名（字符串）映射到各自的 `AdapterStatus` 的字典。

=== "GDScript"
    ```gdscript
    var adapter_status_map: Dictionary # Dictionary[String, AdapterStatus]
    ```

=== "C#"
    ```csharp
    public Dictionary<string, AdapterStatus> AdapterStatusMap { get; }
    ```
