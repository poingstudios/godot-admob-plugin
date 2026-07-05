# ServerSideVerificationOptions

The `ServerSideVerificationOptions` class configures parameters used for securing server-to-server rewarded ad verification callbacks.

## Properties

### `custom_data` / `CustomData`

Custom user-defined parameter string sent back to the validation server.

=== "GDScript"
    ```gdscript
    var custom_data: String
    ```

=== "C#"
    ```csharp
    public string CustomData { get; set; }
    ```

### `user_id` / `UserId`

The unique identifier of the user who completed the rewarded action.

=== "GDScript"
    ```gdscript
    var user_id: String
    ```

=== "C#"
    ```csharp
    public string UserId { get; set; }
    ```
