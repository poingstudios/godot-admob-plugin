# ServerSideVerificationOptions

`ServerSideVerificationOptions` クラスは、サーバー間のリワード広告検証コールバックを保護するために使用されるパラメータを設定します。

## プロパティ

### `custom_data` / `CustomData`

検証サーバーに送信されるユーザー定義のカスタムパラメータ文字列。

=== "GDScript"
    ```gdscript
    var custom_data: String
    ```

=== "C#"
    ```csharp
    public string CustomData { get; set; }
    ```

### `user_id` / `UserId`

リワードアクションを完了したユーザーの一意の識別子。

=== "GDScript"
    ```gdscript
    var user_id: String
    ```

=== "C#"
    ```csharp
    public string UserId { get; set; }
    ```
