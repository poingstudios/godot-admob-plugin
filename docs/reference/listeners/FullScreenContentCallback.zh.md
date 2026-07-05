# FullScreenContentCallback

`FullScreenContentCallback` 类注册与全屏广告格式（[App Open](../classes/AppOpenAd.md)、[Interstitial](../classes/InterstitialAd.md)、[Rewarded](../classes/RewardedAd.md) 和 [Rewarded Interstitial](../classes/RewardedInterstitialAd.md)）展示相关事件的触发器。

## 属性

### `on_ad_clicked` / `OnAdClicked`

在用户点击广告时触发。

=== "GDScript"
    ```gdscript
    var on_ad_clicked: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClicked { get; set; }
    ```

### `on_ad_dismissed_full_screen_content` / `OnAdDismissedFullScreenContent`

在广告关闭/消除且用户返回应用时触发。

=== "GDScript"
    ```gdscript
    var on_ad_dismissed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdDismissedFullScreenContent { get; set; }
    ```

### `on_ad_failed_to_show_full_screen_content` / `OnAdFailedToShowFullScreenContent`

在广告展示失败时触发。接收一个详细说明展示错误的 [`AdError`](../classes/AdError.md)。

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_show_full_screen_content: Callable # Receives AdError
    ```

=== "C#"
    ```csharp
    public Action<AdError> OnAdFailedToShowFullScreenContent { get; set; }
    ```

### `on_ad_impression` / `OnAdImpression`

在广告曝光被记录时触发。

=== "GDScript"
    ```gdscript
    var on_ad_impression: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdImpression { get; set; }
    ```

### `on_ad_showed_full_screen_content` / `OnAdShowedFullScreenContent`

在广告成功展示在屏幕上时触发。

=== "GDScript"
    ```gdscript
    var on_ad_showed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdShowedFullScreenContent { get; set; }
    ```
