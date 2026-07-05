# RewardedInterstitialAd

`RewardedInterstitialAd` 类表示一个激励式插页全屏广告格式，无需用户选择加入即可投放广告，但仍奖励完成观看的用户。

## 属性

### `full_screen_content_callback` / `FullScreenContentCallback`

用于接收展示、关闭或显示失败事件的回调监听器。参见 [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md)。

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

在广告曝光被记录并产生收入时触发。接收一个 [`AdValue`](AdValue.md)。

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## 方法

### `show` / `Show`

展示全屏激励式插页广告覆盖层。

=== "GDScript"
    ```gdscript
    func show(on_user_earned_reward_listener := OnUserEarnedRewardListener.new()) -> void
    ```

    **用法:**
    ```gdscript
    var reward_listener := OnUserEarnedRewardListener.new()
    reward_listener.on_user_earned_reward = func(reward_item: RewardItem):
        print("Rewarded: ", reward_item.amount, " ", reward_item.type)
        
    rewarded_interstitial_ad.show(reward_listener)
    ```

=== "C#"
    ```csharp
    public void Show(OnUserEarnedRewardListener listener = null)
    ```

    **用法:**
    ```csharp
    OnUserEarnedRewardListener listener = new OnUserEarnedRewardListener();
    listener.OnUserEarnedReward = (rewardItem) => {
        GD.Print($"Rewarded: {rewardItem.Amount} {rewardItem.Type}");
    };
    
    rewardedInterstitialAd.Show(listener);
    ```

---

### `destroy` / `Destroy`

销毁原生广告对象并释放资源。

=== "GDScript"
    ```gdscript
    func destroy() -> void
    ```

=== "C#"
    ```csharp
    public void Destroy()
    ```

---

### `get_response_info` / `GetResponseInfo`

返回包含已加载广告的适配器历史记录的 mediation 响应信息。

=== "GDScript"
    ```gdscript
    func get_response_info() -> ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo GetResponseInfo()
    ```

---

### `set_server_side_verification_options` / `SetServerSideVerificationOptions`

配置用于服务端奖励回调的验证参数。

=== "GDScript"
    ```gdscript
    func set_server_side_verification_options(server_side_verification_options: ServerSideVerificationOptions) -> void
    ```

=== "C#"
    ```csharp
    public void SetServerSideVerificationOptions(ServerSideVerificationOptions options)
    ```
