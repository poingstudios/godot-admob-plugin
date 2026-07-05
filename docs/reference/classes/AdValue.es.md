# AdValue

La clase `AdValue` representa el valor estimado de ingresos generado por un anuncio.

## Propiedades

### `precision_type` / `PrecisionType`

Indica el nivel de precisión del valor del anuncio informado.

=== "GDScript"
    ```gdscript
    var precision_type: AdValue.PrecisionType
    ```

=== "C#"
    ```csharp
    public AdValue.PrecisionType PrecisionType { get; }
    ```

### `value_micros` / `ValueMicros`

El valor estimado de ingresos del anuncio en micros (1/1.000.000) de la unidad monetaria.

=== "GDScript"
    ```gdscript
    var value_micros: int
    ```

=== "C#"
    ```csharp
    public long ValueMicros { get; }
    ```

### `currency_code` / `CurrencyCode`

El código de moneda (ISO 4217) del valor del anuncio.

=== "GDScript"
    ```gdscript
    var currency_code: String
    ```

=== "C#"
    ```csharp
    public string CurrencyCode { get; }
    ```
