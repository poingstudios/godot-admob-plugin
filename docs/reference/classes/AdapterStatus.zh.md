# AdapterStatus

`AdapterStatus` 类表示单个中介广告适配器的初始化状态和响应指标。

## 属性

### `latency` / `Latency`

适配器初始化的延迟时间（毫秒）。

=== "GDScript"
    ```gdscript
    var latency: int
    ```

=== "C#"
    ```csharp
    public int Latency { get; set; }
    ```

### `initialization_state` / `State`

适配器的初始化状态。

=== "GDScript"
    ```gdscript
    var initialization_state: int # Matches values from InitializationState enum
    ```

=== "C#"
    ```csharp
    public InitializationState State { get; set; }
    ```

### `description` / `Description`

适配器状态或初始化错误描述的文本说明。

=== "GDScript"
    ```gdscript
    var description: String
    ```

=== "C#"
    ```csharp
    public string Description { get; set; }
    ```
