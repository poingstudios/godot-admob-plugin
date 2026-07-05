# AdValue

`AdValue` クラスは、広告によって生成された推定収益値を表します。

## プロパティ

### `precision_type` / `PrecisionType`

報告された広告価値の精度レベルを示します。

=== "GDScript"
    ```gdscript
    var precision_type: AdValue.PrecisionType
    ```

=== "C#"
    ```csharp
    public AdValue.PrecisionType PrecisionType { get; }
    ```

### `value_micros` / `ValueMicros`

広告の推定収益値（マイクロ単位、1/1,000,000）。

=== "GDScript"
    ```gdscript
    var value_micros: int
    ```

=== "C#"
    ```csharp
    public long ValueMicros { get; }
    ```

### `currency_code` / `CurrencyCode`

広告価値の通貨コード（ISO 4217）。

=== "GDScript"
    ```gdscript
    var currency_code: String
    ```

=== "C#"
    ```csharp
    public string CurrencyCode { get; }
    ```
