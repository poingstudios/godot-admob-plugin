# OnUserEarnedRewardListener

A classe `OnUserEarnedRewardListener` registra callbacks para quando o usuário assistiu com sucesso a um formato de anúncio recompensado e ganhou sua recompensa.

## Propriedades

### `on_user_earned_reward` / `OnUserEarnedReward`

Acionado quando o usuário completa o anúncio recompensado e ganha a recompensa. Recebe um [`RewardedItem`](../classes/RewardedItem.md) contendo os parâmetros da recompensa.

=== "GDScript"
    ```gdscript
    var on_user_earned_reward: Callable # Receives RewardedItem
    ```

=== "C#"
    ```csharp
    public Action<RewardedItem> OnUserEarnedReward { get; set; }
    ```
