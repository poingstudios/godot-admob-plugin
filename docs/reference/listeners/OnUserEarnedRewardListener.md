# OnUserEarnedRewardListener

The `OnUserEarnedRewardListener` class registers callbacks for when the user has successfully watched a rewarded ad format and earned their reward.

## Properties

### `on_user_earned_reward` / `OnUserEarnedReward`

Triggered when the user completes the rewarded ad and earns the reward. Receives a [`RewardedItem`](../classes/RewardedItem.md) containing reward parameters.

=== "GDScript"
    ```gdscript
    var on_user_earned_reward: Callable # Receives RewardedItem
    ```

=== "C#"
    ```csharp
    public Action<RewardedItem> OnUserEarnedReward { get; set; }
    ```
