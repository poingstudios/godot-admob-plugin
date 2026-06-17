# 锚定自适应横幅广告

自适应横幅广告是响应式广告的演变，通过为每个设备动态优化广告尺寸来提高性能。与仅支持固定高度的智能横幅广告不同，自适应横幅广告使您能够指定广告的宽度，然后用该宽度来确定最合适的广告尺寸。

为了选择最佳的广告尺寸，自适应横幅广告依赖固定的宽高比而不是固定的高度。这使得横幅广告在各种设备上保持一致的屏幕比例，从而提供提高性能的潜力。

在使用自适应横幅广告时，需要注意的是，对于特定设备和宽度，它们始终返回固定的尺寸。一旦您在特定设备上测试了您的布局，您就可以放心广告尺寸会保持不变。但是，请记住横幅广告素材的尺寸在不同设备上可能会有所不同。因此，我们建议您的布局适应广告高度的潜在差异。在极少数情况下，可能无法填满整个自适应尺寸，标准的广告素材将被置于该空间中心。

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/banner/anchored-adaptive)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/banner/anchored-adaptive)

## 前提条件
- 完成 [开始使用指南](../../../index.md)

## Godot 中自适应横幅广告的实现说明

1. **宽度信息**：您必须了解将要放置广告的视图的宽度。**这应该考虑设备的宽度以及可能存在的任何安全区域或刘海屏等**。

2. **插件版本**：确保您使用的是最新版本的 Google 移动广告 Godot 插件。对于中介，还要确保您使用的是每个中介适配器的最新版本。

3. **最佳宽度使用**：自适应横幅广告尺寸在利用完整可用宽度时表现最佳。在大多数情况下，这相当于设备屏幕的完整宽度。要考虑可能适用的任何安全区域。

4. **广告尺寸确定**：在使用自适应 AdSize API 时，Google 移动广告 SDK 会自动根据提供的宽度使用优化的广告高度对横幅广告进行尺寸调整。

5. **自适应横幅广告尺寸**：您可以使用三个函数获取自适应广告尺寸：横向使用 `AdSize.get_landscape_anchored_adaptive_banner_ad_size`，纵向使用 `AdSize.get_portrait_anchored_adaptive_banner_ad_size`，以及在执行时获取当前方向的 `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size`。

6. **稳定的尺寸调整**：在特定设备上针对给定宽度返回的尺寸将保持不变。因此，一旦您在特定设备上测试了布局，您就可以确信广告尺寸不会发生变化。

7. **锚定横幅广告高度**：锚定横幅广告的高度始终在一定限制内。它永远不会超过设备高度的 15%，也不会低于 50 个与密度无关的像素 (dp)。

8. **全宽横幅广告**：对于全宽横幅广告，您可以使用 `AdSize.FULL_WIDTH` 常量，而无需指定具体的宽度。

## 快速入门指南

按照以下步骤在 Godot 中实现简单的自适应锚定横幅广告：

1. **获取自适应广告尺寸**：
    - 获取所用设备以密度无关像素 (dp) 为单位的宽度，或者如果您不想使用全屏宽度，可以设置您的自定义宽度。使用 `DisplayServer.window_get_size().x` 可能会很有用。
    - 或者，如果您不想使用全屏宽度，可以设置自定义宽度。
    - 对于全宽横幅广告，使用 `AdSize.FullWidth` 标志。
    - 利用广告尺寸类上相应的静态方法，如 `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)`，以获取当前方向的自适应 `AdSize` 对象。

2. **创建 AdView**：
    - 使用您的广告单元 ID、在步骤 1 中获取的自适应尺寸以及广告所需的展示位置来实例化 `AdView` 对象。

3. **创建广告请求**：
    - 创建广告请求对象。
    - 在准备好的广告视图上使用 `load_ad()` 函数来加载自适应锚定横幅广告，就像使用标准横幅广告请求一样。

## 示例代码演示

下面是加载和刷新自适应横幅广告的脚本示例：
=== "GDScript"

    ```gdscript linenums="1" hl_lines="25 29"
    extends Node2D
    
    var _ad_view : AdView
    var _ad_listener := AdListener.new()
    
    func _ready() -> void:
    	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
    	on_initialization_complete_listener.on_initialization_complete = func(initialization_status : InitializationStatus) -> void:
    		_request_ad_view()
    	MobileAds.initialize(on_initialization_complete_listener)
    	
    	_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
    	_ad_listener.on_ad_loaded = _on_ad_loaded
    
    func _request_ad_view() -> void:
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	
    	if (_ad_view != null):
    		_ad_view.destroy()
    		
    	var adaptive_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)	
    	_ad_view = AdView.new(unit_id, adaptive_size, AdPosition.TOP)
    	_ad_view.ad_listener = _ad_listener
    	
    	_ad_view.load_ad(AdRequest.new())
    
    func _on_ad_failed_to_load(load_ad_error : LoadAdError) -> void:
    	print("_on_ad_failed_to_load: " + load_ad_error.message)
    
    func _on_ad_loaded() -> void:
    	print("_on_ad_loaded")
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="37 41"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class AnchoredAdaptiveExample : Node2D
    {
        private AdView _adView;
        private AdListener _adListener;
    
        public override void _Ready()
        {
            var onInitializationCompleteListener = new OnInitializationCompleteListener
            {
                OnInitializationComplete = (InitializationStatus status) => RequestAdView()
            };
            MobileAds.Initialize(onInitializationCompleteListener);
            
            _adListener = new AdListener
            {
                OnAdFailedToLoad = OnAdFailedToLoad,
                OnAdLoaded = OnAdLoaded
            };
        }
    
        private void RequestAdView()
        {
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/6300978111";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/6300978111";
    
            if (_adView != null)
                _adView.Destroy();
    
            var adaptiveSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
            _adView = new AdView(unitId, adaptiveSize, AdPosition.Top);
            _adView.AdListener = _adListener;
    
            _adView.LoadAd(new AdRequest());
        }
    
        private void OnAdFailedToLoad(LoadAdError loadAdError)
        {
            GD.Print("_on_ad_failed_to_load: " + loadAdError.Message);
        }
    
        private void OnAdLoaded()
        {
            GD.Print("_on_ad_loaded");
        }
    }
    ```

在此背景下，我们使用 `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` 等函数来获取锚定位置横幅广告的尺寸，这与当前的界面方向一致。要为特定方向预加载锚定横幅，您可以利用相应的函数，即 `AdSize.get_portrait_anchored_adaptive_banner_ad_size` 或 `AdSize.get_landscape_anchored_adaptive_banner_ad_size`。
