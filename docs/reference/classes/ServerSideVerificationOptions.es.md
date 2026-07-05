# ServerSideVerificationOptions

La clase `ServerSideVerificationOptions` configura parámetros utilizados para asegurar las devoluciones de llamada de verificación de anuncios recompensados entre servidores.

## Propiedades

### `custom_data` / `CustomData`

Cadena de parámetro personalizado definida por el usuario enviada al servidor de validación.

=== "GDScript"
    ```gdscript
    var custom_data: String
    ```

=== "C#"
    ```csharp
    public string CustomData { get; set; }
    ```

### `user_id` / `UserId`

El identificador único del usuario que completó la acción recompensada.

=== "GDScript"
    ```gdscript
    var user_id: String
    ```

=== "C#"
    ```csharp
    public string UserId { get; set; }
    ```
