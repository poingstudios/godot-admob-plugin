# 智能横幅广告 ⚠️ (已弃用)

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/banner/smart)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/banner/smart)


!!! note "注意"

    请尝试使用较新的 [自适应横幅广告](anchored_adaptive.md) 代替。

要在创建 AdView 时使用智能横幅广告，请将广告尺寸设置为 `AdSize.SMART_BANNER` 属性（或在 C# 中使用 `AdSize.SmartBanner`）。例如：

=== "GDScript"

    ```gdscript linenums="1"
    # 在屏幕顶部创建一个智能横幅广告。
    var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    // 在屏幕顶部创建一个智能横幅广告。
    var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
    ```
