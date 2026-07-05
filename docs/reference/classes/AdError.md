# AdError

The `AdError` class represents error details returned by the Google Mobile Ads SDK when an ad failed to present or perform operations.

## Properties

### `code` / `Code`

The error code indicating the cause of the failure.

=== "GDScript"
    ```gdscript
    var code: int
    ```

=== "C#"
    ```csharp
    public int Code { get; set; }
    ```

### `domain` / `Domain`

The domain from which the error originated (e.g. `"com.google.android.gms.ads"`).

=== "GDScript"
    ```gdscript
    var domain: String
    ```

=== "C#"
    ```csharp
    public string Domain { get; set; }
    ```

### `message` / `Message`

A detailed text message describing the error.

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```

### `cause` / `Cause`

The underlying cause of the error as another `AdError` object, or `null` if none exists.

=== "GDScript"
    ```gdscript
    var cause: AdError
    ```

=== "C#"
    ```csharp
    public AdError Cause { get; set; }
    ```
