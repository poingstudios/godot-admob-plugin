# OnInitializationCompleteListener

`OnInitializationCompleteListener` 类用于监听 [`MobileAds`](../classes/MobileAds.md) SDK 初始化完成事件。

## 属性

### `on_initialization_complete` / `OnInitializationComplete`

在 Mobile Ads SDK 初始化完成时触发。接收一个包含中介适配器就绪状态的 [`InitializationStatus`](../classes/InitializationStatus.md) 对象。

=== "GDScript"
    ```gdscript
    var on_initialization_complete: Callable # Receives InitializationStatus
    ```

=== "C#"
    ```csharp
    public Action<InitializationStatus> OnInitializationComplete { get; set; }
    ```
