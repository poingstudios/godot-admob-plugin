# RewardedAdLoadCallback

`RewardedAdLoadCallback` クラスは、[`RewardedAd`](../classes/RewardedAd.md) ロードリクエストの結果をリッスンするために使用されます。

## プロパティ

### `on_ad_loaded` / `OnAdLoaded`

広告が正常に読み込まれたときにトリガーされます。ロードされた [`RewardedAd`](../classes/RewardedAd.md) インスタンスを受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives RewardedAd
    ```

=== "C#"
    ```csharp
    public Action<RewardedAd> OnAdLoaded { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

ロードリクエストが失敗したときにトリガーされます。ロードエラーの詳細を示す [`LoadAdError`](../classes/LoadAdError.md) を受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```
