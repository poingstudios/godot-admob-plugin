# AdError

`AdError` クラスは、広告の表示や操作の実行に失敗した場合に Google Mobile Ads SDK が返すエラー詳細を表します。

## プロパティ

### `code` / `Code`

失敗の原因を示すエラーコード。

=== "GDScript"
    ```gdscript
    var code: int
    ```

=== "C#"
    ```csharp
    public int Code { get; set; }
    ```

### `domain` / `Domain`

エラーが発生したドメイン（例：`"com.google.android.gms.ads"`）。

=== "GDScript"
    ```gdscript
    var domain: String
    ```

=== "C#"
    ```csharp
    public string Domain { get; set; }
    ```

### `message` / `Message`

エラーを説明する詳細なテキストメッセージ。

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```

### `cause` / `Cause`

エラーの根本原因となる別の `AdError` オブジェクト。存在しない場合は `null`。

=== "GDScript"
    ```gdscript
    var cause: AdError
    ```

=== "C#"
    ```csharp
    public AdError Cause { get; set; }
    ```
