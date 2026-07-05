# AdError

`AdError` 类表示 Google Mobile Ads SDK 在广告展示或操作失败时返回的错误详细信息。

## 属性

### `code` / `Code`

指示失败原因的错误代码。

=== "GDScript"
    ```gdscript
    var code: int
    ```

=== "C#"
    ```csharp
    public int Code { get; set; }
    ```

### `domain` / `Domain`

错误来源的域（例如 `"com.google.android.gms.ads"`）。

=== "GDScript"
    ```gdscript
    var domain: String
    ```

=== "C#"
    ```csharp
    public string Domain { get; set; }
    ```

### `message` / `Message`

描述错误的详细文本消息。

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```

### `cause` / `Cause`

错误的根本原因，另一个 `AdError` 对象，如果不存在则为 `null`。

=== "GDScript"
    ```gdscript
    var cause: AdError
    ```

=== "C#"
    ```csharp
    public AdError Cause { get; set; }
    ```
