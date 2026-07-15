---
name: godot-admob-rewarded
description: Provides instructions to implement, load, show, and handle callbacks (including user rewards) for Rewarded and Rewarded Interstitial ads in GDScript and C#. Use when integrating rewarded or rewarded interstitial ads.
metadata:
  version: 1.0.0
  category: GodotAdMob
---
# Godot AdMob - Rewarded Ads

Assists with implementing Rewarded and Rewarded Interstitial ads using the `RewardedAdLoader` / `RewardedInterstitialAdLoader` and handling rewards in Godot 4.x.

## Rewarded Ads Workflow

1.  **Instantiate Loader**: Set up a `RewardedAdLoader` or `RewardedInterstitialAdLoader`.
2.  **Configure Load Callback**: Define success (`on_ad_loaded`) and failure callbacks.
3.  **Load the Ad**: Call `load()` passing the Ad Unit ID, `AdRequest`, and load callback.
4.  **Configure FullScreenContentCallback**: Set up callbacks for show/dismiss/failure events.
5.  **Create Reward Listener**: Define `OnUserEarnedRewardListener` to receive reward information (amount and type).
6.  **Show the Ad**: Call `ad.show(reward_listener)`.
7.  **Crucial: Destroy the Ad**: Call `ad.destroy()` inside dismissed or show failure callbacks to free native memory.

### Code Examples

=== "GDScript"

    ```gdscript
    var rewarded_ad: RewardedAd
    var rewarded_loader := RewardedAdLoader.new()

    func load_rewarded_ad() -> void:
    	var ad_unit_id := "ca-app-pub-3940256099942544/5224354917" # Test ID
    	var callback := RewardedAdLoadCallback.new()
    	
    	callback.on_ad_loaded = func(ad: RewardedAd) -> void:
    		rewarded_ad = ad
    		print("Rewarded ad loaded.")
    		setup_rewarded_callbacks()
    		
    	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
    		print("Rewarded ad failed to load: ", error.message)
    		
    	rewarded_loader.load(ad_unit_id, AdRequest.new(), callback)

    func setup_rewarded_callbacks() -> void:
    	if not rewarded_ad:
    		return
    	var callbacks := FullScreenContentCallback.new()
    	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
    		print("Rewarded ad dismissed.")
    		rewarded_ad.destroy()
    		rewarded_ad = null
    	callbacks.on_ad_failed_to_show_full_screen_content = func(error: AdError) -> void:
    		print("Rewarded ad failed to show: ", error.message)
    		rewarded_ad.destroy()
    		rewarded_ad = null
    		
    	rewarded_ad.full_screen_content_callback = callbacks

    func show_rewarded_ad() -> void:
    	if not rewarded_ad:
    		print("Rewarded ad not loaded.")
    		return
    		
    	var reward_listener := OnUserEarnedRewardListener.new()
    	reward_listener.on_user_earned_reward = func(rewarded_item: RewardedItem) -> void:
    		print("Player rewarded! Amount: ", rewarded_item.amount, ", Type: ", rewarded_item.type)
    		
    	rewarded_ad.show(reward_listener)
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;

    private RewardedAd _rewardedAd;
    private RewardedAdLoader _rewardedLoader = new RewardedAdLoader();

    public void LoadRewardedAd()
    {
        string adUnitId = "ca-app-pub-3940256099942544/5224354917"; // Test ID
        var callback = new RewardedAdLoadCallback();
        
        callback.OnAdLoaded = (RewardedAd ad) => {
            _rewardedAd = ad;
            GD.Print("Rewarded ad loaded.");
            SetupRewardedCallbacks();
        };
        callback.OnAdFailedToLoad = (error) => {
            GD.Print($"Rewarded ad failed to load: {error.Message}");
        };
        
        _rewardedLoader.Load(adUnitId, new AdRequest(), callback);
    }

    private void SetupRewardedCallbacks()
    {
        if (_rewardedAd == null) return;
        
        var callbacks = new FullScreenContentCallback();
        callbacks.OnAdDismissedFullScreenContent = () => {
            GD.Print("Rewarded ad dismissed.");
            _rewardedAd.Destroy();
            _rewardedAd = null;
        };
        callbacks.OnAdFailedToShowFullScreenContent = (error) => {
            GD.Print($"Rewarded ad failed to show: {error.Message}");
            _rewardedAd.Destroy();
            _rewardedAd = null;
        };
        
        _rewardedAd.FullScreenContentCallback = callbacks;
    }

    public void ShowRewardedAd()
    {
        if (_rewardedAd == null) return;
        
        var rewardListener = new OnUserEarnedRewardListener();
        rewardListener.OnUserEarnedReward = (rewardedItem) => {
            GD.Print($"Player rewarded! Amount: {rewardedItem.Amount}, Type: {rewardedItem.Type}");
        };
        
        _rewardedAd.Show(rewardListener);
    }
    ```
