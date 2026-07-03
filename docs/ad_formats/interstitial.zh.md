# 插屏广告 (Interstitial)

插屏广告是展开式的全屏广告，会覆盖应用的界面，直到被用户关闭。它们在应用执行过程中的自然停顿（例如游戏关卡之间或任务完成之后）策略性地放置最为有效。

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/interstitial)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/interstitial)

## 前提条件
- 完成 [开始使用指南](../index.md)

## 始终使用测试广告进行测试

在开发和测试您的 Godot 应用时，使用测试广告而不是实际的生产广告是至关重要的。否则可能会导致您的 AdMob 账号被停用。

加载测试广告最简单的方法是使用我们专用于 Android 和 iOS 插屏广告的测试广告单元 ID：

=== "Android"
    ```
    ca-app-pub-3940256099942544/1033173712
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/4411468910
    ```

此特定广告单元 ID 已特意配置为对每个请求都投放测试广告。您可以在编码、测试和调试阶段安全地使用它。但是，请记住在准备发布应用时，将此测试广告单元 ID 替换为您自己的广告单元 ID。

要更全面地了解移动广告 SDK 的测试广告如何运作，请参阅我们关于 [测试广告](../enable_test_ads.md) 的文档。

## 插屏广告示例

下面的代码示例演示了如何使用插屏广告。在此示例中，您将创建一个插屏广告的实例，使用 AdRequest 向其加载广告，并通过处理各种生命周期事件来增强功能。

### 加载广告
要加载插屏广告，请使用 `InterstitialAdLoader` 类。传入一个 `InterstitialAdLoadCallback` 以接收加载成功的广告或任何潜在的错误。值得注意的是，与其他格式的加载回调类似，`InterstitialAdLoadCallback` 利用 `LoadAdError` 来提供详细的错误信息。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
    
    func _ready() -> void:
        # 初始化只需执行一次，理想情况下是在应用启动时。
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	# 释放内存
    	if _interstitial_ad:
    		# 始终在所有广告格式上调用此方法以释放 Android/iOS 上的内存
    		_interstitial_ad.destroy()
    		_interstitial_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/1033173712"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/4411468910"
    
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    	interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("插屏广告已加载，UID 为: " + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    
    	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
    
        public override void _Ready()
        {
            // 初始化只需执行一次，理想情况下是在应用启动时。
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            // 释放内存
            if (_interstitialAd != null)
            {
                // 始终在所有广告格式上调用此方法以释放 Android/iOS 上的内存
                _interstitialAd.Destroy();
                _interstitialAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/1033173712";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/4411468910";
    
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("插屏广告已加载");
                    _interstitialAd = interstitialAd;
                }
            };
    
            new InterstitialAdLoader().Load(unitId, new AdRequest(), interstitialAdLoadCallback);
        }
    }
    ```

### 配置 FullScreenContentCallback
`FullScreenContentCallback` 管理与展示您的 `InterstitialAd` 相关的事件。在呈现 `InterstitialAd` 之前，请确保配置了回调：

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
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
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    
    	#...
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("插屏广告已加载，UID 为: " + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    		_interstitial_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
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
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                //...
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("插屏广告已加载");
                    _interstitialAd = interstitialAd;
                    _interstitialAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### 展示广告

插屏广告最好在应用进程的自然过渡期展示。例如在游戏关卡之间或在用户完成一项任务之后。要呈现插屏广告，请使用 `show()` 函数。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3"
    func _on_show_pressed():
    	if _interstitial_ad:
    		_interstitial_ad.show()
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="4"
    private void OnShowPressed()
    {
        if (_interstitialAd != null)
            _interstitialAd.Show();
    }
    ```

### 清理内存

在处理完 `InterstitialAd` 后，请务必在释放对其的引用之前调用 `destroy()` 函数：

=== "GDScript"

    ```gdscript 
    if _interstitial_ad:
    	_interstitial_ad.destroy()
    	_interstitial_ad = null
    ```

=== "C#"

    ```csharp
    if (_interstitialAd != null)
    {
        _interstitialAd.Destroy();
        _interstitialAd = null;
    }
    ```

此操作会通知插件该对象不再被使用，其占用的内存可以被回收。未能调用此方法可能会导致内存泄漏。

## 插屏广告的最佳实践

1. **考虑相关性**：
    - 评估插屏广告是否适合您的应用。
    - 插屏广告最适合在具有自然过渡点的应用中运行，例如任务完成或关卡提升。确保这些过渡点符合用户对动作暂停的预期。

2. **暂停应用活动**：
    - 展示插屏广告时，暂停相关的应用活动，以便广告能有效地使用特定资源。
    - 例如，展示插屏广告时暂停音频输出，以提升广告体验。

3. **优化加载时间**：
    - 提前在调用 `show()` 之前调用 `InterstitialAdLoader.new().load()` 以加载插屏广告。这能确保在需要展示插屏广告时，应用已有一个完全加载的广告准备妥当。

4. **避免广告过度投放**：
    - 避免向用户展示过多的插屏广告。
    - 过于频繁地展示广告可能会损害用户体验并降低点击率。在不不断干扰用户的前提下，找到一个平衡点，让用户可以开心地享受您的应用。

请记住，实施插屏广告应该提升，而不是损害您应用中的用户体验。

## 其他参考

### 示例
- [示例项目](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：所有广告格式用法的最简展示。
