# AdError

A classe `AdError` representa detalhes de erro retornados pelo SDK Google Mobile Ads quando um anúncio falha ao apresentar ou executar operações.

## Propriedades

### `code` / `Code`

O código de erro que indica a causa da falha.

=== "GDScript"
    ```gdscript
    var code: int
    ```

=== "C#"
    ```csharp
    public int Code { get; set; }
    ```

### `domain` / `Domain`

O domínio de origem do erro (ex. `"com.google.android.gms.ads"`).

=== "GDScript"
    ```gdscript
    var domain: String
    ```

=== "C#"
    ```csharp
    public string Domain { get; set; }
    ```

### `message` / `Message`

Uma mensagem de texto detalhada descrevendo o erro.

=== "GDScript"
    ```gdscript
    var message: String
    ```

=== "C#"
    ```csharp
    public string Message { get; set; }
    ```

### `cause` / `Cause`

A causa subjacente do erro como outro objeto `AdError`, ou `null` se não existir.

=== "GDScript"
    ```gdscript
    var cause: AdError
    ```

=== "C#"
    ```csharp
    public AdError Cause { get; set; }
    ```
