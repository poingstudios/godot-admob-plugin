# OnUserEarnedRewardListener

`OnUserEarnedRewardListener` クラスは、ユーザーがリワード広告フォーマットを正常に視聴して報酬を獲得したときのコールバックを登録します。

## プロパティ

### `on_user_earned_reward` / `OnUserEarnedReward`

ユーザーがリワード広告を完了して報酬を獲得したときにトリガーされます。報酬パラメータを含む [`RewardedItem`](../classes/RewardedItem.md) を受け取ります。

=== "GDScript"
    ```gdscript
    var on_user_earned_reward: Callable # Receives RewardedItem
    ```

=== "C#"
    ```csharp
    public Action<RewardedItem> OnUserEarnedReward { get; set; }
    ```
