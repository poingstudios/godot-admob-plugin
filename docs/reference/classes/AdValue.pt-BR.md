# AdValue

A classe `AdValue` representa o valor estimado de receita gerado por um anúncio.

## Propriedades

### `precision_type` / `PrecisionType`

Indica o nível de precisão do valor do anúncio relatado.

=== "GDScript"
    ```gdscript
    var precision_type: AdValue.PrecisionType
    ```

=== "C#"
    ```csharp
    public AdValue.PrecisionType PrecisionType { get; }
    ```

### `value_micros` / `ValueMicros`

O valor estimado da receita do anúncio em micros (1/1.000.000) da unidade monetária.

=== "GDScript"
    ```gdscript
    var value_micros: int
    ```

=== "C#"
    ```csharp
    public long ValueMicros { get; }
    ```

### `currency_code` / `CurrencyCode`

O código da moeda (ISO 4217) do valor do anúncio.

=== "GDScript"
    ```gdscript
    var currency_code: String
    ```

=== "C#"
    ```csharp
    public string CurrencyCode { get; }
    ```
