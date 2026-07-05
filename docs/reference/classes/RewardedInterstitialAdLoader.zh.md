# RewardedInterstitialAdLoader

`RewardedInterstitialAdLoader` 类负责执行异步广告请求以加载 [`RewardedInterstitialAd`](RewardedInterstitialAd.md) 实例。

## 方法

### `load` / `Load`

发送激励式插页广告的加载请求。

=== "GDScript"
    ```gdscript
    func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        rewarded_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
    ) -> void
    ```

    **用法:**
    ```gdscript
    var loader := RewardedInterstitialAdLoader.new()
    var callback := RewardedInterstitialAdLoadCallback.new()
    
    callback.on_ad_loaded = func(rewarded_interstitial_ad: RewardedInterstitialAd):
        print("Ad loaded!")
        
        # Define reward callback
        var reward_listener := OnUserEarnedRewardListener.new()
        reward_listener.on_user_earned_reward = func(reward_item: RewardItem):
            print("Rewarded: ", reward_item.amount, " ", reward_item.type)
            
        rewarded_interstitial_ad.show(reward_listener)
        
    callback.on_ad_failed_to_load = func(load_ad_error: LoadAdError):
        print("Failed to load: ", load_ad_error.message)
        
    loader.load("ca-app-pub-3940256099942544/5354046379", AdRequest.new(), callback)
    ```

=== "C#"
    ```csharp
    public void Load(string adUnitId, AdRequest adRequest, RewardedInterstitialAdLoadCallback callback = null)
    ```

    **用法:**
    ```csharp
    RewardedInterstitialAdLoader loader = new RewardedInterstitialAdLoader();
    RewardedInterstitialAdLoadCallback callback = new RewardedInterstitialAdLoadCallback();
    
    callback.OnAdLoaded = (rewardedInterstitialAd) => {
        GD.Print("Ad loaded!");
        
        // Define reward callback
        OnUserEarnedRewardListener rewardListener = new OnUserEarnedRewardListener();
        rewardListener.OnUserEarnedReward = (rewardItem) => {
            GD.Print($"Rewarded: {rewardItem.Amount} {rewardItem.Type}");
        };
        
        rewardedInterstitialAd.Show(rewardListener);
    };
    callback.OnAdFailedToLoad = (loadAdError) => {
        GD.Print("Failed to load: " + loadAdError.Message);
    };
    
    loader.Load("ca-app-pub-3940256099942544/5354046379", new AdRequest(), callback);
    ```
