# AdapterResponseInfo

`AdapterResponseInfo` クラスには、メディエーションウォーターフォールチェーン内の個々のメディエーション広告ネットワークアダプターの実行ステータスに関するメタデータが含まれています。

## プロパティ

### `adapter_class_name` / `AdapterClassName`

メディエーション広告アダプターのクラス名（例：`"com.google.ads.mediation.admob.AdMobAdapter"`）。

=== "GDScript"
    ```gdscript
    var adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string AdapterClassName { get; set; }
    ```

### `ad_source_id` / `AdSourceId`

広告ソースの識別子。

=== "GDScript"
    ```gdscript
    var ad_source_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceId { get; set; }
    ```

### `ad_source_name` / `AdSourceName`

広告ネットワーク/ソースの名前（例：`"AdMob"` または `"AppLovin"`）。

=== "GDScript"
    ```gdscript
    var ad_source_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceName { get; set; }
    ```

### `ad_source_instance_id` / `AdSourceInstanceId`

広告ソースのインスタンス ID。

=== "GDScript"
    ```gdscript
    var ad_source_instance_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceId { get; set; }
    ```

### `ad_source_instance_name` / `AdSourceInstanceName`

広告ソースインスタンスの名前。

=== "GDScript"
    ```gdscript
    var ad_source_instance_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceName { get; set; }
    ```

### `ad_unit_mapping` / `AdUnitMapping`

この特定の広告ユニットに対して AdMob コンソールで設定されたマッピングパラメータを含む辞書。

=== "GDScript"
    ```gdscript
    var ad_unit_mapping: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary AdUnitMapping { get; set; }
    ```

### `ad_error` / `AdError`

このアダプターが広告の読み込みまたは配信に失敗した場合のエラーメタデータ。読み込みが成功した場合は `null`。

=== "GDScript"
    ```gdscript
    var ad_error: AdError
    ```

=== "C#"
    ```csharp
    public AdError AdError { get; set; }
    ```

### `latency_millis` / `LatencyMillis`

アダプターリクエストのレイテンシ（ミリ秒）。

=== "GDScript"
    ```gdscript
    var latency_millis: int
    ```

=== "C#"
    ```csharp
    public int LatencyMillis { get; set; }
    ```
