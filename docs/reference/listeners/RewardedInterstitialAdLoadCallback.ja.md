# RewardedInterstitialAdLoadCallback

`RewardedInterstitialAdLoadCallback` クラスは、[`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md) ロードリクエストの結果をリッスンするために使用されます。

## プロパティ

### `on_ad_loaded` / `OnAdLoaded`

広告が正常に読み込まれたときにトリガーされます。ロードされた [`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md) インスタンスを受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives RewardedInterstitialAd
    ```

=== "C#"
    ```csharp
    public Action<RewardedInterstitialAd> OnAdLoaded { get; set; }
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
