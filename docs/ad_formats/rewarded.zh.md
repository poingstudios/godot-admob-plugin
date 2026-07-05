# 激励广告

激励视频广告是一种沉浸式的全屏视频广告，允许用户选择是否完整观看。作为对他们时间和注意力的回报，用户将获得应用内奖励或福利。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/rewarded)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/rewarded)

## 前提条件
- 完成[入门指南](../index.zh.md)


## 始终使用测试广告进行测试

在开发和测试 Godot 应用时，请务必使用测试广告，而不是线上的生产环境广告。否则可能会导致您的 AdMob 账号被停用。

加载测试广告最直接的方法是使用我们专用的 Android 和 iOS 激励广告测试广告单元 ID：

=== "Android"
    ```
    ca-app-pub-3940256099942544/5224354917
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/1712485313
    ```

该广告单元 ID 已专门配置为对所有请求都返回测试广告。您可以在编码、测试和调试阶段安全地使用它。但是，请记得在准备发布应用时，将此测试广告单元 ID 替换为您自己的广告单元 ID。

欲深入了解移动广告 SDK 的测试广告工作原理，请参阅[测试广告](../enable_test_ads.zh.md)文档。


## 激励广告示例

下面的代码示例演示了如何使用 `Rewarded`。在此示例中，您将创建一个 `RewardedAd` 实例，使用 `AdRequest` 将广告加载到其中，并通过处理各种生命周期事件来增强功能。


### 加载广告
要加载激励广告，请使用 [`RewardedAdLoader`](../reference/classes/RewardedAdLoader.md) 类。传入 [`RewardedAdLoadCallback`](../reference/listeners/RewardedAdLoadCallback.md) 以接收加载好的 [`RewardedAd`](../reference/classes/RewardedAd.md) 或任何可能的错误。值得注意的是，与其他格式的加载回调类似，[`RewardedAdLoadCallback`](../reference/listeners/RewardedAdLoadCallback.md) 利用 [`LoadAdError`](../reference/classes/LoadAdError.md) 来提供详细的错误信息。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
    
    func _ready() -> void:
        # The initializate needs to be done only once, ideally at app launch.
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	# free memory
    	if _rewarded_ad:
    		# always call this method on all AdFormats to free memory on Android/iOS
    		_rewarded_ad.destroy()
    		_rewarded_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/5224354917"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/1712485313"
    
    	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
    	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
    		print("rewarded ad loaded" + str(rewarded_ad._uid))
    		_rewarded_ad = rewarded_ad
    
    	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
    
        public override void _Ready()
        {
            // The initializate needs to be done only once, ideally at app launch.
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            // free memory
            if (_rewardedAd != null)
            {
                // always call this method on all AdFormats to free memory on Android/iOS
                _rewardedAd.Destroy();
                _rewardedAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/5224354917";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/1712485313";
    
            var rewardedAdLoadCallback = new RewardedAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (RewardedAd rewardedAd) => 
                {
                    GD.Print("rewarded ad loaded");
                    _rewardedAd = rewardedAd;
                }
            };
    
            new RewardedAdLoader().Load(unitId, new AdRequest(), rewardedAdLoadCallback);
        }
    }
    ```

### [可选] 验证服务器端验证 (SSV) 回调
对于在服务器端验证（[Android](https://developers.google.com/admob/android/ssv) / [iOS](https://developers.google.com/admob/ios/ssv)）回调中需要额外数据的应用，可以使用 [`ServerSideVerificationOptions`](../reference/classes/ServerSideVerificationOptions.md) 进行配置。分配给激励广告对象的任何字符串值都会传输到 SSV 回调的 `custom_data` 查询参数中。如果未设置自定义数据，则 SSV 回调中将不存在 `custom_data` 查询参数。

以下代码片段说明了如何在请求广告之前在激励广告对象上建立自定义数据：

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5 6 7"
    rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
        print("rewarded ad loaded" + str(rewarded_ad._uid))
        
        var server_side_verification_options := ServerSideVerificationOptions.new()
        server_side_verification_options.custom_data = "TEST PURPOSE"
        server_side_verification_options.user_id = "user_id_test"
        rewarded_ad.set_server_side_verification_options(server_side_verification_options)
        
        _rewarded_ad = rewarded_ad
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6 7 8"
    rewardedAdLoadCallback.OnAdLoaded = (RewardedAd rewardedAd) => 
    {
        GD.Print("rewarded ad loaded");
        
        var serverSideVerificationOptions = new ServerSideVerificationOptions();
        serverSideVerificationOptions.CustomData = "TEST PURPOSE";
        serverSideVerificationOptions.UserId = "user_id_test";
        rewardedAd.SetServerSideVerificationOptions(serverSideVerificationOptions);
        
        _rewardedAd = rewardedAd;
    };
    ```
!!! note

    自定义奖励字符串是经过[百分号编码](https://en.wikipedia.org/wiki/Percent-encoding)的，在从 SSV 回调中解析时可能需要进行解码。

### 配置 FullScreenContentCallback
[`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) 管理与 [`RewardedAd`](../reference/classes/RewardedAd.md) 显示相关的事件。在展示 [`RewardedAd`](../reference/classes/RewardedAd.md) 之前，请确保配置了该回调：

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
    var _full_screen_content_callback := FullScreenContentCallback.new()
    
    func _ready() -> void:
    	#...
    	_full_screen_content_callback.on_ad_clicked = func() -> void:
    		print("on_ad_clicked")
    	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
    		print("on_ad_dismissed_full_screen_content")
    	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
    		print("on_ad_failed_to_show_full_screen_content")
    	_full_screen_content_callback.on_ad_impression = func() -> void:
    		print("on_ad_impression")
    	_full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
    		print("on_ad_showed_full_screen_content")
    
    func _on_load_pressed():
    	#...
    	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
    
    	#...
    
    	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
    		print("rewarded ad loaded" + str(rewarded_ad._uid))
    		_rewarded_ad = rewarded_ad
    		_rewarded_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
        private FullScreenContentCallback _fullScreenContentCallback;
    
        public override void _Ready()
        {
            //...
            _fullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdClicked = () => GD.Print("on_ad_clicked"),
                OnAdDismissedFullScreenContent = () => GD.Print("on_ad_dismissed_full_screen_content"),
                OnAdFailedToShowFullScreenContent = (AdError adError) => GD.Print("on_ad_failed_to_show_full_screen_content"),
                OnAdImpression = () => GD.Print("on_ad_impression"),
                OnAdShowedFullScreenContent = () => GD.Print("on_ad_showed_full_screen_content")
            };
        }
    
        private void OnLoadPressed()
        {
            //...
            var rewardedAdLoadCallback = new RewardedAdLoadCallback
            {
                //...
                OnAdLoaded = (RewardedAd rewardedAd) => 
                {
                    GD.Print("rewarded ad loaded");
                    _rewardedAd = rewardedAd;
                    _rewardedAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### 展示广告

在展示激励广告时，您将使用 [`OnUserEarnedRewardListener`](../reference/listeners/OnUserEarnedRewardListener.md) 对象来管理与奖励相关的事件。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
    var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
    
    func _ready() -> void:
    	#...
    	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
    		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
    
    #...
    func _on_show_pressed():
    	if _rewarded_ad:
    		_rewarded_ad.show(on_user_earned_reward_listener)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="27"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
        private OnUserEarnedRewardListener _onUserEarnedRewardListener;
    
        public override void _Ready()
        {
            //...
            _onUserEarnedRewardListener = new OnUserEarnedRewardListener
            {
                OnUserEarnedReward = (RewardedItem rewardedItem) =>
                {
                    GD.Print($"on_user_earned_reward, rewarded_item: rewarded {rewardedItem.Amount} {rewardedItem.Type}");
                }
            };
        }
    
        //...
        private void OnShowPressed()
        {
            if (_rewardedAd != null)
                _rewardedAd.Show(_onUserEarnedRewardListener);
        }
    }
    ```

### 清理内存

在 `RewardedAd` 使用完毕后，在释放对其引用之前调用 `destroy()` 函数非常重要：

=== "GDScript"

    ```gdscript
    if _rewarded_ad:
        _rewarded_ad.destroy()
        _rewarded_ad = null
    ```

=== "C#"

    ```csharp
    if (_rewardedAd != null)
    {
        _rewardedAd.Destroy();
        _rewardedAd = null;
    }
    ```


此操作向插件发出信号，表明该对象已不再使用，可以回收它所占用的内存。如果不调用此方法，可能会导致内存泄漏。

## 更多参考

### 示例
- [示例项目](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：演示所有广告格式用法的极简示例
