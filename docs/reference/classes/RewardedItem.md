# RewardedItem

The `RewardedItem` class represents the reward structure (type and amount) granted to a user for watching a rewarded ad.

## Properties

### `amount` / `Amount`

The amount of the reward granted.

=== "GDScript"
    ```gdscript
    var amount: int
    ```

=== "C#"
    ```csharp
    public int Amount { get; set; }
    ```

### `type` / `Type`

The type of the reward granted (e.g. `"coins"`, `"lives"`).

=== "GDScript"
    ```gdscript
    var type: String
    ```

=== "C#"
    ```csharp
    public string Type { get; set; }
    ```
