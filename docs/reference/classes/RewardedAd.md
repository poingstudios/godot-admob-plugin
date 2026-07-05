# RewardedAd

The `RewardedAd` class represents a full-screen rewarded ad format where users can choose to watch an ad in exchange for in-game/in-app rewards.

## Properties

### `full_screen_content_callback` / `FullScreenContentCallback`

The callback listener to receive events about presentation, dismissal, or failure to show.

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Triggered when an ad impression is recorded and revenue has been generated.

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## Methods

### `show` / `Show`

Presents the full-screen rewarded ad overlay.

=== "GDScript"
    ```gdscript
    func show(on_user_earned_reward_listener := OnUserEarnedRewardListener.new()) -> void
    ```

    **Usage:**
    ```gdscript
    var reward_listener := OnUserEarnedRewardListener.new()
    reward_listener.on_user_earned_reward = func(reward_item: RewardItem):
        print("User earned: ", reward_item.amount, " ", reward_item.type)
        
    rewarded_ad.show(reward_listener)
    ```

=== "C#"
    ```csharp
    public void Show(OnUserEarnedRewardListener listener = null)
    ```

    **Usage:**
    ```csharp
    OnUserEarnedRewardListener listener = new OnUserEarnedRewardListener();
    listener.OnUserEarnedReward = (rewardItem) => {
        GD.Print($"User earned: {rewardItem.Amount} {rewardItem.Type}");
    };
    
    rewardedAd.Show(listener);
    ```

---

### `destroy` / `Destroy`

Destroys the native ad object and frees up resources.

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

Returns the mediation response info containing adapter history for the loaded ad.

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

Configures the verification parameters used for server-side reward callbacks.

=== "GDScript"
    ```gdscript
    func set_server_side_verification_options(server_side_verification_options: ServerSideVerificationOptions) -> void
    ```

=== "C#"
    ```csharp
    public void SetServerSideVerificationOptions(ServerSideVerificationOptions options)
    ```
