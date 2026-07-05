# RewardedInterstitialAdLoadCallback

`RewardedInterstitialAdLoadCallback` 类用于监听 [`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md) 加载请求的结果。

## 属性

### `on_ad_loaded` / `OnAdLoaded`

在广告成功加载时触发。接收已加载的 [`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md) 实例。

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives RewardedInterstitialAd
    ```

=== "C#"
    ```csharp
    public Action<RewardedInterstitialAd> OnAdLoaded { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

在加载请求失败时触发。接收一个详细说明加载错误的 [`LoadAdError`](../classes/LoadAdError.md)。

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```
