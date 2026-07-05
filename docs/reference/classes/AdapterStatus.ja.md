# AdapterStatus

`AdapterStatus` クラスは、個々のメディエーション広告アダプターの初期化ステータスと応答メトリクスを表します。

## プロパティ

### `latency` / `Latency`

アダプター初期化のレイテンシ（ミリ秒）。

=== "GDScript"
    ```gdscript
    var latency: int
    ```

=== "C#"
    ```csharp
    public int Latency { get; set; }
    ```

### `initialization_state` / `State`

アダプターの初期化状態。

=== "GDScript"
    ```gdscript
    var initialization_state: int # Matches values from InitializationState enum
    ```

=== "C#"
    ```csharp
    public InitializationState State { get; set; }
    ```

### `description` / `Description`

アダプターのステータスまたは初期化エラーの説明テキスト。

=== "GDScript"
    ```gdscript
    var description: String
    ```

=== "C#"
    ```csharp
    public string Description { get; set; }
    ```
