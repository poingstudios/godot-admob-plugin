# ServerSideVerificationOptions

`ServerSideVerificationOptions` 类配置用于保护服务端到服务端的激励广告验证回调的参数。

## 属性

### `custom_data` / `CustomData`

发送到验证服务器的用户自定义参数字符串。

=== "GDScript"
    ```gdscript
    var custom_data: String
    ```

=== "C#"
    ```csharp
    public string CustomData { get; set; }
    ```

### `user_id` / `UserId`

完成激励操作的用户的唯一标识符。

=== "GDScript"
    ```gdscript
    var user_id: String
    ```

=== "C#"
    ```csharp
    public string UserId { get; set; }
    ```
