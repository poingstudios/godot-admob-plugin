# FormError

`FormError` 类包含有关在加载同意表单、展示或更新同意信息期间发生的错误信息。

## 属性

### `error_code` / `ErrorCode`

与该错误关联的数字错误代码。

=== "GDScript"
    ```gdscript
    var error_code: int
    ```

=== "C#"
    ```csharp
    public int ErrorCode { get; set; }
    ```

### `message` / `Message`

错误的可读描述。

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```
