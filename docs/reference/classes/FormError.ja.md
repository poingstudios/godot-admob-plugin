# FormError

`FormError` クラスには、同意フォームのロード、表示、または同意情報の更新中に発生したエラーに関する情報が含まれています。

## プロパティ

### `error_code` / `ErrorCode`

エラーに関連付けられた数値エラーコード。

=== "GDScript"
    ```gdscript
    var error_code: int
    ```

=== "C#"
    ```csharp
    public int ErrorCode { get; set; }
    ```

### `message` / `Message`

エラーの可読な説明。

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```
