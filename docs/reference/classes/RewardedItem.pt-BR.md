# RewardedItem

A classe `RewardedItem` representa a estrutura de recompensa (tipo e quantidade) concedida a um usuário por assistir a um anúncio recompensado.

## Propriedades

### `amount` / `Amount`

A quantidade da recompensa concedida.

=== "GDScript"
    ```gdscript
    var amount: int
    ```

=== "C#"
    ```csharp
    public int Amount { get; set; }
    ```

### `type` / `Type`

O tipo de recompensa concedida (ex. `"coins"`, `"lives"`).

=== "GDScript"
    ```gdscript
    var type: String
    ```

=== "C#"
    ```csharp
    public string Type { get; set; }
    ```
