# AdInspectorClosedListener

`AdInspectorClosedListener` クラスは、[`MobileAds.open_ad_inspector()`](../classes/MobileAds.md#open_ad_inspector-openadinspector) を介して開かれたネイティブ Ad Inspector のクローズイベントをリッスンするために使用されます。

## プロパティ

### `on_ad_inspector_closed` / `OnAdInspectorClosed`

Ad Inspector が閉じられたときにトリガーされます。発生したエラーの詳細を示す辞書、または通常に閉じられた場合は空の辞書を受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_inspector_closed: Callable # Receives error: Dictionary
    ```

=== "C#"
    ```csharp
    public Action<Dictionary> OnAdInspectorClosed { get; set; }
    ```
