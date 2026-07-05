# ResponseInfo

`ResponseInfo` クラスは、読み込まれた広告のメタデータと、メディエーションリクエストチェーンに関与するアダプターの応答を含みます。

## プロパティ

### `loaded_adapter_response_info` / `LoadedAdapterResponseInfo`

広告を正常にロードした特定のメディエーションアダプターのメタデータ。成功したものがない場合は `null`。

=== "GDScript"
    ```gdscript
    var loaded_adapter_response_info: AdapterResponseInfo
    ```

=== "C#"
    ```csharp
    public AdapterResponseInfo LoadedAdapterResponseInfo { get; set; }
    ```

### `adapter_responses` / `AdapterResponses`

メディエーションウォーターフォールチェーン内の各アダプターの応答リスト。

=== "GDScript"
    ```gdscript
    var adapter_responses: Array[AdapterResponseInfo]
    ```

=== "C#"
    ```csharp
    public List<AdapterResponseInfo> AdapterResponses { get; set; }
    ```

### `response_extras` / `ResponseExtras`

広告サーバーによって設定されたメタデータの追加フィールドを含む辞書。

=== "GDScript"
    ```gdscript
    var response_extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary ResponseExtras { get; set; }
    ```

### `mediation_adapter_class_name` / `MediationAdapterClassName`

広告をロードしたメディエーション広告アダプターのクラス名。

=== "GDScript"
    ```gdscript
    var mediation_adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string MediationAdapterClassName { get; set; }
    ```

### `response_id` / `ResponseId`

広告応答の一意の識別子。

=== "GDScript"
    ```gdscript
    var response_id: String
    ```

=== "C#"
    ```csharp
    public string ResponseId { get; set; }
    ```
