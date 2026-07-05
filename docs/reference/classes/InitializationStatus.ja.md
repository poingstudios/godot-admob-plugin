# InitializationStatus

`InitializationStatus` クラスは、Google Mobile Ads SDK と設定されたメディエーションアダプターの初期化詳細を保持します。

## プロパティ

### `adapter_status_map` / `AdapterStatusMap`

アダプタークラス名（文字列）をそれぞれの `AdapterStatus` にマッピングする辞書。

=== "GDScript"
    ```gdscript
    var adapter_status_map: Dictionary # Dictionary[String, AdapterStatus]
    ```

=== "C#"
    ```csharp
    public Dictionary<string, AdapterStatus> AdapterStatusMap { get; }
    ```
