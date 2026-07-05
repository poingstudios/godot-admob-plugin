# OnUserEarnedRewardListener

La clase `OnUserEarnedRewardListener` registra devoluciones de llamada para cuando el usuario ha visto con éxito un formato de anuncio recompensado y ha obtenido su recompensa.

## Propiedades

### `on_user_earned_reward` / `OnUserEarnedReward`

Se activa cuando el usuario completa el anuncio recompensado y obtiene la recompensa. Recibe un [`RewardedItem`](../classes/RewardedItem.md) que contiene los parámetros de la recompensa.

=== "GDScript"
    ```gdscript
    var on_user_earned_reward: Callable # Receives RewardedItem
    ```

=== "C#"
    ```csharp
    public Action<RewardedItem> OnUserEarnedReward { get; set; }
    ```
