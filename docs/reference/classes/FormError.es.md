# FormError

La clase `FormError` contiene información sobre un error que ocurrió durante la carga del formulario de consentimiento, la presentación o las actualizaciones de la información de consentimiento.

## Propiedades

### `error_code` / `ErrorCode`

El código numérico de error asociado al error.

=== "GDScript"
    ```gdscript
    var error_code: int
    ```

=== "C#"
    ```csharp
    public int ErrorCode { get; set; }
    ```

### `message` / `Message`

Una descripción legible del error.

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```
