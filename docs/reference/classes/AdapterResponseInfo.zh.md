# AdapterResponseInfo

`AdapterResponseInfo` 类包含中介瀑布链中单个中介广告网络适配器执行状态的元数据。

## 属性

### `adapter_class_name` / `AdapterClassName`

中介广告适配器的类名（例如：`"com.google.ads.mediation.admob.AdMobAdapter"`）。

=== "GDScript"
    ```gdscript
    var adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string AdapterClassName { get; set; }
    ```

### `ad_source_id` / `AdSourceId`

广告来源的标识符。

=== "GDScript"
    ```gdscript
    var ad_source_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceId { get; set; }
    ```

### `ad_source_name` / `AdSourceName`

广告网络/来源的名称（例如：`"AdMob"` 或 `"AppLovin"`）。

=== "GDScript"
    ```gdscript
    var ad_source_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceName { get; set; }
    ```

### `ad_source_instance_id` / `AdSourceInstanceId`

广告来源的实例 ID。

=== "GDScript"
    ```gdscript
    var ad_source_instance_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceId { get; set; }
    ```

### `ad_source_instance_name` / `AdSourceInstanceName`

广告来源实例的名称。

=== "GDScript"
    ```gdscript
    var ad_source_instance_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceName { get; set; }
    ```

### `ad_unit_mapping` / `AdUnitMapping`

一个字典，包含在 AdMob 控制台中为此特定广告单元设置的映射参数。

=== "GDScript"
    ```gdscript
    var ad_unit_mapping: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary AdUnitMapping { get; set; }
    ```

### `ad_error` / `AdError`

如果此适配器无法加载或提供广告，则包含错误元数据；如果加载成功，则为 `null`。

=== "GDScript"
    ```gdscript
    var ad_error: AdError
    ```

=== "C#"
    ```csharp
    public AdError AdError { get; set; }
    ```

### `latency_millis` / `LatencyMillis`

适配器请求的延迟时间（毫秒）。

=== "GDScript"
    ```gdscript
    var latency_millis: int
    ```

=== "C#"
    ```csharp
    public int LatencyMillis { get; set; }
    ```
