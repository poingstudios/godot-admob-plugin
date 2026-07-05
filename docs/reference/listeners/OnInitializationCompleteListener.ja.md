# OnInitializationCompleteListener

`OnInitializationCompleteListener` クラスは、[`MobileAds`](../classes/MobileAds.md) SDK 初期化の完了イベントをリッスンするために使用されます。

## プロパティ

### `on_initialization_complete` / `OnInitializationComplete`

Mobile Ads SDK の初期化が完了したときにトリガーされます。メディエーションアダプターの準備状態を含む [`InitializationStatus`](../classes/InitializationStatus.md) オブジェクトを受け取ります。

=== "GDScript"
    ```gdscript
    var on_initialization_complete: Callable # Receives InitializationStatus
    ```

=== "C#"
    ```csharp
    public Action<InitializationStatus> OnInitializationComplete { get; set; }
    ```
