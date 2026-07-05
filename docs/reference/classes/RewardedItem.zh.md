# RewardedItem

`RewardedItem` 类表示因观看激励广告而授予用户的奖励结构（类型和数量）。

## 属性

### `amount` / `Amount`

授予的奖励数量。

=== "GDScript"
    ```gdscript
    var amount: int
    ```

=== "C#"
    ```csharp
    public int Amount { get; set; }
    ```

### `type` / `Type`

授予的奖励类型（例如 `"coins"`、`"lives"`）。

=== "GDScript"
    ```gdscript
    var type: String
    ```

=== "C#"
    ```csharp
    public string Type { get; set; }
    ```
