# ServerSideVerificationOptions

A classe `ServerSideVerificationOptions` configura parâmetros usados para proteger callbacks de verificação de anúncios recompensados entre servidores.

## Propriedades

### `custom_data` / `CustomData`

String de parâmetro personalizado definida pelo usuário enviada ao servidor de validação.

=== "GDScript"
    ```gdscript
    var custom_data: String
    ```

=== "C#"
    ```csharp
    public string CustomData { get; set; }
    ```

### `user_id` / `UserId`

O identificador único do usuário que completou a ação recompensada.

=== "GDScript"
    ```gdscript
    var user_id: String
    ```

=== "C#"
    ```csharp
    public string UserId { get; set; }
    ```
