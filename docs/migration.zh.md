# 迁移 SDK 版本

本页面涵盖当前和先前版本的迁移。

## 从 v4 迁移到 v5

以下小节描述了 Godot AdMob 编辑器插件主要版本 4 和 5 之间的破坏性变更和行为差异。

### 移除 Smart Banner

旧版 `Smart Banner` 格式已被 Google 弃用，并已在 v5 中从插件中彻底移除。

| 语言 | 移除的属性 | 替代方案 |
| :--- | :--- | :--- |
| **GDScript** | `AdSize.SMART_BANNER` | [`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size()`](reference/classes/AdSize.md#adaptive-banners) |
| **C#** | `AdSize.SmartBanner` | [`AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize()`](reference/classes/AdSize.md#adaptive-banners) |

!!! danger "破坏性变更（Breaking Change）"
    静态属性 `AdSize.SMART_BANNER`（GDScript）和 `AdSize.SmartBanner`（C#）已被彻底移除。你必须更新脚本以使用自适应尺寸方法。

#### 如何迁移
请改用**锚定自适应横幅广告**。它们是官方的现代替代方案，会根据设备宽度和屏幕密度动态计算最佳高度。

!!! note "向后兼容回退"
    为安全起见，Android 和 iOS 原生插件均实现了自动回退：如果旧场景或布局仍发送宽度为 `-1` 且高度为 `-1` 的尺寸，原生桥接会将其拦截，并返回与屏幕宽度匹配的标准锚定自适应横幅广告尺寸。

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

### Gradle 依赖项变更

原生 Android 插件现在引入了新的 Next-Gen SDK：

* **旧依赖项：** `com.google.android.gms:play-services-ads`
* **新依赖项：** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! info "自动中介排除"
    为防止在使用中介适配器（可能传递性地引入旧版 SDK）时出现符号重复和冲突，Godot 导出插件会自动修改你的 Android 导出的 `build.gradle`，以排除 `play-services-ads` 和 `play-services-ads-lite`。无需在你的导出配置中进行手动排除。
