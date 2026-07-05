# AdInspectorClosedListener

`AdInspectorClosedListener` 类用于监听原生 Ad Inspector 的关闭事件，该检查器通过 [`MobileAds.open_ad_inspector()`](../classes/MobileAds.md#open_ad_inspector-openadinspector) 打开。

## 属性

### `on_ad_inspector_closed` / `OnAdInspectorClosed`

在 Ad Inspector 关闭时触发。接收一个详细说明任何错误的字典，如果正常关闭则为空字典。

=== "GDScript"
    ```gdscript
    var on_ad_inspector_closed: Callable # Receives error: Dictionary
    ```

=== "C#"
    ```csharp
    public Action<Dictionary> OnAdInspectorClosed { get; set; }
    ```
