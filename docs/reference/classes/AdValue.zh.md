# AdValue

`AdValue` 类表示广告产生的预估收入值。

## 属性

### `precision_type` / `PrecisionType`

指示报告的广告价值的精确度级别。

=== "GDScript"
    ```gdscript
    var precision_type: AdValue.PrecisionType
    ```

=== "C#"
    ```csharp
    public AdValue.PrecisionType PrecisionType { get; }
    ```

### `value_micros` / `ValueMicros`

广告的预估收入值，单位为货币单位的微数（1/1,000,000）。

=== "GDScript"
    ```gdscript
    var value_micros: int
    ```

=== "C#"
    ```csharp
    public long ValueMicros { get; }
    ```

### `currency_code` / `CurrencyCode`

广告价值的货币代码（ISO 4217）。

=== "GDScript"
    ```gdscript
    var currency_code: String
    ```

=== "C#"
    ```csharp
    public string CurrencyCode { get; }
    ```
