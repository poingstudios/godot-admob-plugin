# RewardedAd

`RewardedAd` クラスは、ユーザーがゲーム内/アプリ内報酬と引き換えに広告を視聴できる全画面リワード広告フォーマットを表します。

## プロパティ

### `full_screen_content_callback` / `FullScreenContentCallback`

表示、閉じる、表示失敗のイベントを受け取るコールバックリスナー。 [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md) を参照してください。

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

広告インプレッションが記録され収益が発生したときにトリガーされます。[`AdValue`](AdValue.md) を受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## メソッド

### `show` / `Show`

全画面のリワード広告オーバーレイを表示します。

=== "GDScript"
    ```gdscript
    func show(on_user_earned_reward_listener := OnUserEarnedRewardListener.new()) -> void
    ```

    **使用法:**
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

    **使用法:**
    ```csharp
    OnUserEarnedRewardListener listener = new OnUserEarnedRewardListener();
    listener.OnUserEarnedReward = (rewardItem) => {
        GD.Print($"User earned: {rewardItem.Amount} {rewardItem.Type}");
    };
    
    rewardedAd.Show(listener);
    ```

---

### `destroy` / `Destroy`

ネイティブ広告オブジェクトを破棄してリソースを解放します。

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

読み込まれた広告のアダプター履歴を含むメディエーション応答情報を返します。

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

サーバー側リワードコールバックに使用される検証パラメータを設定します。

=== "GDScript"
    ```gdscript
    func set_server_side_verification_options(server_side_verification_options: ServerSideVerificationOptions) -> void
    ```

=== "C#"
    ```csharp
    public void SetServerSideVerificationOptions(ServerSideVerificationOptions options)
    ```
