# 折叠式横幅广告 (Collapsible Banner Ads)

折叠式横幅广告是最初以较大覆盖层展示的横幅广告，带有一个可将其折叠回原始请求的横幅广告尺寸的按钮。折叠式横幅广告旨在提高原本尺寸较小的锚定广告的性能。本指南展示了如何为现有的横幅广告版位开启折叠式横幅广告。

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/banner/collapsible)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/banner/collapsible)

## 前提条件
- 完成 [横幅广告开始使用指南](get_started.md)。

## 实现

确保您的 `AdView` 定义为您希望用户在常规（折叠）横幅状态下看到的尺寸。在 `AdRequest` 的 extras 参数中包含以 `collapsible` 为键、广告版位为值的参数。

折叠式版位定义了展开区域如何锚定到横幅广告。

| 版位值 | 行为 | 预期使用场景 |
|---|---|---|
| `top` | 展开后广告的顶部与折叠后广告的顶部对齐。 | 广告放置在屏幕顶部。 |
| `bottom` | 展开后广告的底部与折叠后广告的底部对齐。 | 广告放置在屏幕底部。 |

如果加载的广告是折叠式横幅，横幅在放置在视图层次结构中时会立即展示折叠式覆盖层。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="2"
    var ad_request := AdRequest.new()
    ad_request.extras["collapsible"] = "bottom"

    _ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="2"
    var adRequest = new AdRequest();
    adRequest.Extras["collapsible"] = "bottom";
    
    _adView.LoadAd(adRequest);
    ```

!!! info "重要信息"
    大型锚定自适应横幅广告不提供折叠式横幅功能。如果您的应用需要折叠功能，请使用 [标准锚定自适应横幅广告](sizes/anchored_adaptive.md)。

## 广告刷新行为

对于在 AdMob 网页界面中为横幅广告配置了自动刷新的应用，当为横幅插槽请求折叠式横幅广告时，后续的广告刷新将不会请求折叠式横幅广告。这是因为在每次刷新时展示折叠式横幅可能会对用户体验产生负面影响。

如果您想在会话后期加载另一个折叠式横幅广告，可以使用包含 `collapsible` 参数的请求手动加载广告。

## 检查加载的广告是否是折叠式的

非折叠式横幅广告有资格返回以响应折叠式横幅请求，以最大化性能。调用 `is_collapsible()`（在 C# 中为 `IsCollapsible()`）来检查最后加载的横幅广告是否为折叠式。

=== "GDScript"
    ```gdscript linenums="1" hl_lines="6"
    func _ready() -> void:
    	# ...
    	_ad_view.ad_listener.on_ad_loaded = _on_ad_loaded

    func _on_ad_loaded() -> void:
    	var is_collapsible: bool = _ad_view.is_collapsible()
    	print("广告已加载。折叠式: %s" % is_collapsible)
    ```

=== "C#"
    ```csharp linenums="1" hl_lines="7"
    private void RegisterAdListener()
    {
    	_adView.AdListener = new AdListener
    	{
    		OnAdLoaded = () => 
    		{
    			bool isCollapsible = _adView.IsCollapsible();
    			GD.Print($"广告已加载。折叠式: {isCollapsible}");
    		}
    	};
    }
    ```

## 中介 (Mediation)

折叠式横幅广告仅适用于 Google 需求方。通过中介填充的广告将展示为普通的非折叠式横幅广告。
