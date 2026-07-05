# RewardedItem

La clase `RewardedItem` representa la estructura de recompensa (tipo y cantidad) otorgada a un usuario por ver un anuncio recompensado.

## Propiedades

### `amount` / `Amount`

La cantidad de la recompensa otorgada.

=== "GDScript"
    ```gdscript
    var amount: int
    ```

=== "C#"
    ```csharp
    public int Amount { get; set; }
    ```

### `type` / `Type`

El tipo de recompensa otorgada (ej. `"coins"`, `"lives"`).

=== "GDScript"
    ```gdscript
    var type: String
    ```

=== "C#"
    ```csharp
    public string Type { get; set; }
    ```
