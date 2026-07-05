# AdError

La clase `AdError` representa detalles de error devueltos por el SDK de Google Mobile Ads cuando un anuncio no se pudo presentar o ejecutar operaciones.

## Propiedades

### `code` / `Code`

El código de error que indica la causa de la falla.

=== "GDScript"
    ```gdscript
    var code: int
    ```

=== "C#"
    ```csharp
    public int Code { get; set; }
    ```

### `domain` / `Domain`

El dominio desde el cual se originó el error (ej. `"com.google.android.gms.ads"`).

=== "GDScript"
    ```gdscript
    var domain: String
    ```

=== "C#"
    ```csharp
    public string Domain { get; set; }
    ```

### `message` / `Message`

Un mensaje de texto detallado que describe el error.

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```

### `cause` / `Cause`

La causa subyacente del error como otro objeto `AdError`, o `null` si no existe.

=== "GDScript"
    ```gdscript
    var cause: AdError
    ```

=== "C#"
    ```csharp
    public AdError Cause { get; set; }
    ```
