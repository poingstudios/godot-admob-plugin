# FormError

The `FormError` class contains information about an error that occurred during consent form loading, presentation, or consent information updates.

## Properties

### `error_code` / `ErrorCode`

The numeric error code associated with the error.

=== "GDScript"
    ```gdscript
    var error_code: int
    ```

=== "C#"
    ```csharp
    public int ErrorCode { get; set; }
    ```

### `message` / `Message`

A human-readable description of the error.

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```
