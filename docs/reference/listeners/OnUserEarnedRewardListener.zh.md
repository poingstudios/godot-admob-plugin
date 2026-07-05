# OnUserEarnedRewardListener

`OnUserEarnedRewardListener` 类在用户成功观看激励广告格式并获得奖励时注册回调。

## 属性

### `on_user_earned_reward` / `OnUserEarnedReward`

在用户完成激励广告并获得奖励时触发。接收一个包含奖励参数的 [`RewardedItem`](../classes/RewardedItem.md)。

=== "GDScript"
    ```gdscript
    var on_user_earned_reward: Callable # Receives RewardedItem
    ```

=== "C#"
    ```csharp
    public Action<RewardedItem> OnUserEarnedReward { get; set; }
    ```
