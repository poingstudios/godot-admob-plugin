# AdListener

`AdListener` 类允许您监听通过 [`AdView`](../classes/AdView.md) 加载的横幅广告和通过 [`NativeOverlayAd`](../classes/NativeOverlayAd.md) 加载的原生叠加广告的生命周期事件。

## 属性

所有属性都是可调用委托（C# 中为 Action 委托），在相应的广告事件发生时触发：

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

### `on_ad_closed` / `OnAdClosed`

在用户关闭广告覆盖层或返回应用时触发。

=== "GDScript"
    ```gdscript
    var on_ad_closed: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClosed { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

在广告加载失败时触发。接收一个详细说明错误的 [`LoadAdError`](../classes/LoadAdError.md)。

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
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

### `on_ad_loaded` / `OnAdLoaded`

在广告成功加载时触发。

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdLoaded { get; set; }
    ```

### `on_ad_opened` / `OnAdOpened`

在广告打开覆盖应用程序的全屏覆盖层时触发。

=== "GDScript"
    ```gdscript
    var on_ad_opened: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdOpened { get; set; }
    ```
