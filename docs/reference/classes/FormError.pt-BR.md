# FormError

A classe `FormError` contém informações sobre um erro que ocorreu durante o carregamento do formulário de consentimento, apresentação ou atualizações das informações de consentimento.

## Propriedades

### `error_code` / `ErrorCode`

O código numérico de erro associado ao erro.

=== "GDScript"
    ```gdscript
    var error_code: int
    ```

=== "C#"
    ```csharp
    public int ErrorCode { get; set; }
    ```

### `message` / `Message`

Uma descrição legível do erro.

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```
