# AdValue

The `AdValue` class represents the monetary value earned from an ad impression.

## Properties

### `currency_code` / `CurrencyCode`

The ISO 4217 currency code associated with the revenue value (e.g., `"USD"`).

=== "GDScript"
    ```gdscript
    var currency_code: String
    ```

=== "C#"
    ```csharp
    public string CurrencyCode { get; }
    ```

### `precision` / `Precision`

The precision type of the reported revenue.

=== "GDScript"
    ```gdscript
    var precision: int # Matches values from PrecisionType enum
    ```

=== "C#"
    ```csharp
    public PrecisionType Precision { get; }
    ```

### `value_micros` / `ValueMicros`

The monetary value of the ad impression in micro-units of the currency (e.g., $1.00 is represented as `1000000`).

=== "GDScript"
    ```gdscript
    var value_micros: int
    ```

=== "C#"
    ```csharp
    public long ValueMicros { get; }
    ```
