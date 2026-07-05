# RewardedItem

`RewardedItem` クラスは、リワード広告を視聴したユーザーに付与される報酬構造（タイプと量）を表します。

## プロパティ

### `amount` / `Amount`

付与される報酬の量。

=== "GDScript"
    ```gdscript
    var amount: int
    ```

=== "C#"
    ```csharp
    public int Amount { get; set; }
    ```

### `type` / `Type`

付与される報酬のタイプ（例：`"coins"`、`"lives"`）。

=== "GDScript"
    ```gdscript
    var type: String
    ```

=== "C#"
    ```csharp
    public string Type { get; set; }
    ```
