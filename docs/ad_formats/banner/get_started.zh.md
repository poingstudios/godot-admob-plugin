# 开始使用

横幅广告是矩形广告，由图片或文本组成，并集成在应用的布局中。这些广告在用户与应用互动时保持在屏幕上，并可在指定的时间间隔后自动刷新。如果您是移动广告的新手，横幅广告是您广告实现之旅的一个绝佳起点。

本指南演示了如何将 AdMob 的横幅广告无缝集成到 Godot 应用中。除了代码片段和详细说明外，它还提供了关于适当调整横幅尺寸的指导，并引导您获取其他资源以获得进一步帮助。

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/banner)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/banner)

## 前提条件
- 完成 [开始使用指南](../../index.md)

## 始终使用测试广告进行测试

在开发和测试您的 Godot 应用时，使用测试广告而不是实际的生产广告是至关重要的。否则可能会导致您的 AdMob 账号被停用。

加载测试广告最简单的方法是使用我们专用于 Android 和 iOS 横幅的测试广告单元 ID：

=== "Android"
    ```
    ca-app-pub-3940256099942544/6300978111
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/2934735716
    ```

此特定广告单元 ID 已特意配置为对每个请求都投放测试广告。您可以在编码、测试和调试阶段安全地使用它。但是，请记住在准备发布应用时，将此测试广告单元 ID 替换为您自己的广告单元 ID。

要更全面地了解移动广告 SDK 的测试广告如何运作，请参阅我们关于 [测试广告](../../enable_test_ads.md) 的文档。

## AdView 示例

下面的代码示例演示了如何使用 AdView。在此示例中，您将创建一个 AdView 的实例，使用 AdRequest 向其加载广告，并通过处理各种生命周期事件来增强功能。

### 创建 AdView (横幅广告)
使用横幅广告的第一步是在附加到节点的 GDScript 或 C# 脚本中创建 AdView 的实例。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="20"
    extends Node2D
    
    var _ad_view : AdView
    
    func _ready():
    	# 初始化只需执行一次，理想情况下是在应用启动时。
    	MobileAds.initialize()
    
    func _create_ad_view() -> void:
    	# 释放内存
    	if _ad_view:
    		destroy_ad_view()
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/2934735716"
    
    	_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="28"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class BannerAd : Node2D
    {
        private AdView _adView;
    
        public override void _Ready()
        {
            // 初始化只需执行一次，理想情况下是在应用启动时。
            MobileAds.Initialize();
        }
    
        private void CreateAdView()
        {
            // 释放内存
            if (_adView != null)
                DestroyAdView();
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/6300978111";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/2934735716";
    
            _adView = new AdView(unitId, AdSize.Banner, AdPosition.Top);
        }
    }
    ```

Godot 中 AdView 的构造函数具有以下参数：

- `unit_id`：AdView 应从中加载广告的 AdMob 广告单元 ID。
- `AdSize`：您希望使用的 AdMob 广告尺寸（详情请参阅 [AdView 尺寸](#adview-sizes)）。
- `AdPosition`：横幅广告应放置的位置。`AdPosition`（GDScript）或 `AdPosition`（C#）类公开了有效广告位置值的静态实例（例如 `AdPosition.TOP`）。

请注意根据平台使用不同的广告单元。在 iOS 上发起广告请求时，应使用 iOS 广告单元；而在 Android 上，则必须使用 Android 广告单元。

#### (可选) 生成具有自定义位置的 AdView
除了使用标准锚点（如 `Top` 或 `Bottom`），您还可以定义特定的 `x` 和 `y` 坐标，以将横幅放置在自定义的点上。这些坐标决定了横幅视图左上角在屏幕上的放置位置。

=== "GDScript"

    ```gdscript linenums="1"
    # 在屏幕坐标 (0, 50) 处创建横幅。
    var custom_position := AdPosition.custom(0, 50)
    _ad_view := AdView.new(unit_id, AdSize.BANNER, custom_position)
    ```

=== "C#"

    ```csharp linenums="1"
    // 在屏幕坐标 (0, 50) 处创建横幅。
    var customPosition = AdPosition.Custom(0, 50);
    _adView = new AdView(unitId, AdSize.Banner, customPosition);
    ```

#### (可选) 生成具有自定义尺寸的 AdView
除了使用预定义的 AdSize 常量外，您还可以为广告指定自定义尺寸：

=== "GDScript"

    ```gdscript linenums="1"
    var ad_size := AdSize.new(200, 200)
    _ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    var adSize = new AdSize(200, 200);
    _adView = new AdView(unitId, adSize, AdPosition.Top);
    ```

### 加载 AdView (横幅广告)
使用 AdView 的第二阶段涉及构建 AdRequest，然后将其传递给 `load_ad()` 方法。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5"
    func _on_load_banner_pressed():
    	if _ad_view == null:
    		_create_ad_view()
    	var ad_request := AdRequest.new()
    	_ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6"
    private void OnLoadBannerPressed()
    {
        if (_adView == null)
            CreateAdView();
        var adRequest = new AdRequest();
        _adView.LoadAd(adRequest);
    }
    ```

### 监听 AdView 信号
要定制广告的行为，您可以连接到广告生命周期中的各种事件，如加载、打开、关闭等。要监听这些事件，您可以注册一个 `AdListener`：

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3 18"
    func register_ad_listener() -> void:
    	if _ad_view != null:
    		var ad_listener := AdListener.new()
    		
    		ad_listener.on_ad_failed_to_load = func(load_ad_error : LoadAdError) -> void:
    			print("_on_ad_failed_to_load: " + load_ad_error.message)
    		ad_listener.on_ad_clicked = func() -> void:
    			print("_on_ad_clicked")
    		ad_listener.on_ad_closed = func() -> void:
    			print("_on_ad_closed")
    		ad_listener.on_ad_impression = func() -> void:
    			print("_on_ad_impression")
    		ad_listener.on_ad_loaded = func() -> void:
    			print("_on_ad_loaded")
    		ad_listener.on_ad_opened = func() -> void:
    			print("_on_ad_opened")
    			
    		_ad_view.ad_listener = ad_listener
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5"
    private void RegisterAdListener()
    {
        if (_adView != null)
        {
            _adView.AdListener = new AdListener
            {
                OnAdFailedToLoad = (LoadAdError loadAdError) => GD.Print("_on_ad_failed_to_load: " + loadAdError.Message),
                OnAdClicked = () => GD.Print("_on_ad_clicked"),
                OnAdClosed = () => GD.Print("_on_ad_closed"),
                OnAdImpression = () => GD.Print("_on_ad_impression"),
                OnAdLoaded = () => GD.Print("_on_ad_loaded"),
                OnAdOpened = () => GD.Print("_on_ad_opened")
            };
        }
    }
    ```

### 销毁 AdView (横幅广告)
在使用完 AdView 后，请记住调用 `destroy()` 以释放分配的资源并释放内存。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4"
    func destroy_ad_view() -> void:
    	if _ad_view:
    		# 始终在所有广告格式上调用此方法以释放 Android/iOS 上的内存
    		_ad_view.destroy()
    		_ad_view = null
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="6"
    private void DestroyAdView()
    {
        if (_adView != null)
        {
            // 始终在所有广告格式上调用此方法以释放 Android/iOS 上的内存
            _adView.Destroy();
            _adView = null;
        }
    }
    ```

这就是全部内容！您的应用现在已完全准备好展示来自 AdMob 的横幅广告。

## AdView 尺寸 {: #adview-sizes }

下表展示了标准的横幅广告尺寸：

| 尺寸 dp (宽x高)                   | 描述                                          | 可用性             | AdSize 常量      |
|----------------------------------|-----------------------------------------------|--------------------|------------------|
| 320x50                           | 标准横幅广告                                 | 手机和平板电脑     | BANNER           |
| 320x100                          | 大型横幅广告                                 | 手机和平板电脑     | LARGE_BANNER     |
| 300x250                          | IAB 中等矩形广告                             | 手机和平板电脑     | MEDIUM_RECTANGLE |
| 468x60                           | IAB 全尺寸横幅广告                           | 平板电脑           | FULL_BANNER      |
| 728x90                           | IAB 排行榜横幅广告                           | 平板电脑           | LEADERBOARD      |
| 提供宽度 x 自适应高度            | [自适应横幅广告](sizes/anchored_adaptive.md)  | 手机和平板电脑     | N/A              |

## 其他参考

### 示例
- [示例项目](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：所有广告格式用法的最简展示。
