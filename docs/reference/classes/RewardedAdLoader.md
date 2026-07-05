# RewardedAdLoader

The `RewardedAdLoader` class is responsible for executing asynchronous ad requests to load `RewardedAd` instances.

## Methods

### `load` / `Load`

Sends a load request for a Rewarded ad.

=== "GDScript"
    ```gdscript
    func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        rewarded_ad_load_callback := RewardedAdLoadCallback.new()
    ) -> void
    ```

    **Usage:**
    ```gdscript
    var loader := RewardedAdLoader.new()
    var callback := RewardedAdLoadCallback.new()
    
    callback.on_ad_loaded = func(rewarded_ad: RewardedAd):
        print("Ad loaded!")
        
        # Define reward callback
        var reward_listener := OnUserEarnedRewardListener.new()
        reward_listener.on_user_earned_reward = func(reward_item: RewardItem):
            print("Rewarded: ", reward_item.amount, " ", reward_item.type)
            
        rewarded_ad.show(reward_listener)
        
    callback.on_ad_failed_to_load = func(load_ad_error: LoadAdError):
        print("Failed to load: ", load_ad_error.message)
        
    loader.load("ca-app-pub-3940256099942544/5224354917", AdRequest.new(), callback)
    ```

=== "C#"
    ```csharp
    public void Load(string adUnitId, AdRequest adRequest, RewardedAdLoadCallback callback = null)
    ```

    **Usage:**
    ```csharp
    RewardedAdLoader loader = new RewardedAdLoader();
    RewardedAdLoadCallback callback = new RewardedAdLoadCallback();
    
    callback.OnAdLoaded = (rewardedAd) => {
        GD.Print("Ad loaded!");
        
        // Define reward callback
        OnUserEarnedRewardListener rewardListener = new OnUserEarnedRewardListener();
        rewardListener.OnUserEarnedReward = (rewardItem) => {
            GD.Print($"Rewarded: {rewardItem.Amount} {rewardItem.Type}");
        };
        
        rewardedAd.Show(rewardListener);
    };
    callback.OnAdFailedToLoad = (loadAdError) => {
        GD.Print("Failed to load: " + loadAdError.Message);
    };
    
    loader.Load("ca-app-pub-3940256099942544/5224354917", new AdRequest(), callback);
    ```
