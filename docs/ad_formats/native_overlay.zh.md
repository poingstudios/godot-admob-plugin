# 原生重叠广告 (Native Overlay Ads)

原生重叠广告是一种专门的广告格式，允许您在应用内容上方展示 [原生广告 (Native Ad)](https://support.google.com/admob/answer/6329630)。与需要您自己构建 UI 的标准原生广告不同，原生重叠广告使用 **模板 (Templates)** 来提供一致且易于集成的体验，这与其他平台类似。

!!! note "注意"
    这种格式非常适合想要获得原生外观但又不想承受手动 UI 布局复杂性的游戏和应用。

## 前提条件

在您继续之前，请执行以下操作：

- 完成 [开始使用指南](../index.md)。

## 始终使用测试广告进行测试

下表包含您可用于请求测试广告的广告单元 ID。它们已特别配置为对每个请求都返回测试广告而不是生产广告，因此可以安全使用。

但是，在您在 AdMob 网页界面中注册应用并创建了自己的广告单元 ID 以在应用中使用之后，请在开发期间显式地 [将您的设备配置为测试设备](../enable_test_ads.md)。

=== "Android"

    ```
    ca-app-pub-3940256099942544/2247696110
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/3986624511
    ```

## 实现

集成原生重叠广告的主要步骤有：

1. 加载原生广告
2. 定义模板样式
3. 渲染模板
4. 监听广告事件
5. 显示/隐藏或销毁广告

### 加载原生广告

加载原生广告是通过使用 `NativeOverlayAd` 类上的 `load()` 方法完成的。您需要提供广告单元 ID、一个 `AdRequest`、`NativeAdOptions` 以及一个完成回调。

=== "GDScript"

    ```gdscript linenums="1"
    var _native_overlay_ad: NativeOverlayAd

    # 这些广告单元配置为始终投放测试广告。
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/2247696110"
            return "ca-app-pub-3940256099942544/3986624511"

    func _load_native_ad() -> void:
        var ad_request := AdRequest.new()
        var options := NativeAdOptions.new()
        
        # 可选: 配置选项
        options.ad_choices_placement = AdChoicesPlacement.Values.TOP_RIGHT
        options.media_aspect_ratio = NativeMediaAspectRatio.Values.ANY

        NativeOverlayAd.load(_ad_unit_id, ad_request, options, _on_ad_load_finished)

    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        if error:
            print("原生广告加载失败: ", error.message)
            return
        
        print("原生广告加载成功")
        _native_overlay_ad = ad
        _render_native_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    private NativeOverlayAd _nativeOverlayAd;

    // 这些广告单元配置为始终投放测试广告。
    private string _adUnitId => OS.GetName() == "Android" 
        ? "ca-app-pub-3940256099942544/2247696110" 
        : "ca-app-pub-3940256099942544/3986624511";

    private void LoadNativeAd()
    {
        var adRequest = new AdRequest();
        var options = new NativeAdOptions();

        // 可选: 配置选项
        options.AdChoicesPlacement = AdChoicesPlacement.Values.TopRight;
        options.MediaAspectRatio = NativeMediaAspectRatio.Values.Any;

        NativeOverlayAd.Load(_adUnitId, adRequest, options, OnAdLoadFinished);
    }

    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        if (error != null)
        {
            GD.Print("原生广告加载失败: " + error.Message);
            return;
        }

        GD.Print("原生广告加载成功");
        _nativeOverlayAd = ad;
        RenderNativeAd();
    }
    ```

### 定义模板样式

您可以使用 `NativeTemplateStyle` 来自定义广告的外观。有两种主要的模板可用：`SMALL` (小) 和 `MEDIUM` (中)。

=== "GDScript"

    ```gdscript linenums="1"
    func _render_native_ad() -> void:
        var style := NativeTemplateStyle.new()
        
        # 选择模板: SMALL 或 MEDIUM
        style.template_id = NativeTemplateStyle.MEDIUM
        
        # 自定义背景颜色
        style.main_background_color = Color.WHITE
        
        # 自定义号召性用语 (CTA) 按钮
        var cta_style := NativeTemplateTextStyle.new()
        cta_style.background_color = Color.DODGER_BLUE
        cta_style.text_color = Color.WHITE
        cta_style.font_size = 15.0
        cta_style.style = NativeTemplateFontStyle.Values.BOLD
        
        style.call_to_action_text = cta_style
        
        # 在特定位置渲染模板
        _native_overlay_ad.render_template(style, AdPosition.BOTTOM)
    ```

=== "C#"

    ```csharp linenums="1"
    private void RenderNativeAd()
    {
        var style = new NativeTemplateStyle();

        // 选择模板: Small 或 Medium
        style.TemplateId = NativeTemplateStyle.Medium;

        // 自定义背景颜色
        style.MainBackgroundColor = Colors.White;

        // 自定义号召性用语 (CTA) 按钮
        var ctaStyle = new NativeTemplateTextStyle();
        ctaStyle.BackgroundColor = Colors.DodgerBlue;
        ctaStyle.TextColor = Colors.White;
        ctaStyle.FontSize = 15.0f;
        ctaStyle.Style = NativeTemplateFontStyle.Bold;

        style.CallToActionText = ctaStyle;

        // 在特定位置渲染模板
        _nativeOverlayAd.RenderTemplate(style, AdPosition.Bottom);
    }
    ```

### 广告位置

您可以使用 `AdPosition` 类将广告放置在几个预定义的位置或自定义的 XY 坐标。

- `AdPosition.TOP`
- `AdPosition.BOTTOM`
- `AdPosition.CENTER`
- `AdPosition.TOP_LEFT` / `AdPosition.TOP_RIGHT`
- `AdPosition.BOTTOM_LEFT` / `AdPosition.BOTTOM_RIGHT`
- `AdPosition.custom(x, y)`

### 监听广告事件

要处理用户交互，您可以使用 `NativeOverlayAd` 实例的 `ad_listener` 属性。

=== "GDScript"

    ```gdscript linenums="1"
    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        # ... 检查加载 ...
        
        ad.ad_listener.on_ad_clicked = func(): print("广告被点击")
        ad.ad_listener.on_ad_impression = func(): print("广告展示成功记录")
        ad.ad_listener.on_ad_opened = func(): print("广告被打开")
        ad.ad_listener.on_ad_closed = func(): print("广告被关闭")
    ```

=== "C#"

    ```csharp linenums="1"
    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        // ... 检查加载 ...

        ad.AdListener.OnAdClicked = () => GD.Print("广告被点击");
        ad.AdListener.OnAdImpression = () => GD.Print("广告展示成功记录");
        ad.AdListener.OnAdOpened = () => GD.Print("广告被打开");
        ad.AdListener.OnAdClosed = () => GD.Print("广告被关闭");
    }
    ```

### 显示/隐藏和销毁

一旦渲染，您可以控制广告的可见性或将其完全销毁以释放资源。

=== "GDScript"

    ```gdscript linenums="1"
    # 隐藏广告
    _native_overlay_ad.hide()

    # 再次显示广告
    _native_overlay_ad.show()

    # 销毁广告 (使用完毕后必须调用)
    _native_overlay_ad.destroy()
    _native_overlay_ad = null
    ```

=== "C#"

    ```csharp linenums="1"
    // 隐藏广告
    _nativeOverlayAd.Hide();

    // 再次显示广告
    _nativeOverlayAd.Show();

    // 销毁广告 (使用完毕后必须调用)
    _nativeOverlayAd.Destroy();
    _nativeOverlayAd = null;
    ```

## 最佳实践

- **销毁**：在您不再需要该广告时，务必调用 `destroy()` 以防止原生平台上的内存泄漏。
- **后台加载**：您可以在后台加载广告，并在准备展示它们时才调用 `render_template()`。
- **模板选择**：将 `SMALL` 模板用于列表或狭窄空间，而 `MEDIUM` 模板用于更突出的展示位置，例如关卡过渡屏幕。

## 其他资源

- [示例项目](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：有关完整实现，请参见 `Native` 标签页。
