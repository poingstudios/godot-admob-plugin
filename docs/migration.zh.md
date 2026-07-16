# 迁移 SDK 版本

本页面涵盖当前和先前版本的 Godot AdMob 编辑器插件的迁移指南。

## 从 v4 迁移到 v5

以下小节描述了 Godot AdMob 编辑器插件主要版本 4 和 5 之间的破坏性变更、行为差异和新增 API。

### 下一代 (Next-Gen) Android SDK 迁移

版本 5.0.0 将底层的 Android 原生插件从旧版的 Google Mobile Ads SDK 依赖项迁移到了现代的 Google Mobile Ads Next-Gen SDK：

* **旧依赖项 (v4)：** `com.google.android.gms:play-services-ads`
* **新依赖项 (v5)：** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! danger "中介库冲突"
    由于某些旧版第三方广告中介适配器可能会隐式引入旧的 `play-services-ads` 或 `play-services-ads-lite` 库，在编译 Android 项目时可能会遇到类重复或符号冲突的错误。

#### 自动修复机制
在 v5.0.0 中，Godot 导出插件会自动拦截 Android 的导出过程，并自动修复项目的 Gradle 配置文件 (`res://android/build/build.gradle` 或 `res://android/build/app/build.gradle`) 以显式排除旧的依赖：

```groovy
// 由 Poing Godot AdMob 插件自动添加以支持 GMA Next-Gen SDK
configurations.configureEach {
    exclude group: "com.google.android.gms", module: "play-services-ads"
    exclude group: "com.google.android.gms", module: "play-services-ads-lite"
}
```
无需开发人员进行任何手动干预或配置。

---

### 移除 Smart Banner

旧版 `Smart Banner` 格式已被 Google 弃用，并已在 v5 中从插件中彻底移除。

| 语言 | 移除的尺寸 API | 替代方案 |
| :--- | :--- | :--- |
| **GDScript** | `AdSize.get_smart_banner_ad_size()` | [`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)`](reference/classes/AdSize.md) |
| **C#** | `AdSize.GetSmartBannerAdSize()` | [`AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(width)`](reference/classes/AdSize.md) |

!!! note "向后兼容回退"
    为安全起见，Android 和 iOS 原生插件均实现了自动回退：如果旧场景或布局仍发送宽度为 `-1` 且高度为 `-1` 的尺寸，原生桥接会将其拦截，并返回与屏幕宽度匹配的标准锚定自适应横幅广告尺寸。

#### 如何迁移
请改用**锚定自适应横幅广告**。它们是官方的现代替代方案，会根据设备宽度和屏幕密度动态计算最佳高度。

=== "v4"

    === "GDScript"

        ```gdscript
        # 旧版 Smart Banner
        var ad_view := AdView.new(unit_id, AdSize.get_smart_banner_ad_size(), AdPosition.Values.TOP)
        ```

    === "C#"

        ```csharp
        // 旧版 Smart Banner
        var adView = new AdView(unitId, AdSize.GetSmartBannerAdSize(), AdPosition.Values.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        # 匹配全宽的自适应横幅广告
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        // 匹配全宽的自适应横幅广告
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

---

### AdPosition API 变更 (破坏性变更)

在 5.0.0 版本中，[`AdPosition`](reference/classes/AdPosition.md) API 已经从基本的整型枚举更改为类实例。这允许您使用预定义的静态坐标或自定义像素偏移量来定位横幅广告。

| v4 API (已弃用) | v5 API (替代方案) |
| :--- | :--- |
| `AdPosition.Values.TOP` | `AdPosition.TOP` |
| `AdPosition.Values.BOTTOM` | `AdPosition.BOTTOM` |
| `AdPosition.Values.LEFT` | `AdPosition.LEFT` |
| `AdPosition.Values.RIGHT` | `AdPosition.RIGHT` |
| `AdPosition.Values.TOP_LEFT` | `AdPosition.TOP_LEFT` |
| `AdPosition.Values.TOP_RIGHT` | `AdPosition.TOP_RIGHT` |
| `AdPosition.Values.BOTTOM_LEFT` | `AdPosition.BOTTOM_LEFT` |
| `AdPosition.Values.BOTTOM_RIGHT` | `AdPosition.BOTTOM_RIGHT` |
| `AdPosition.Values.CENTER` | `AdPosition.CENTER` |
| 不支持自定义定位 | `AdPosition.custom(x, y)` |

#### 如何迁移
请更新您的横幅广告创建 and 位置更新代码，以传递 [`AdPosition`](reference/classes/AdPosition.md) 类的实例，而不是原始枚举值。

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.Values.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, adSize, AdPosition.Values.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        # 预定义位置
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        
        # 自定义坐标 (例如 x=0, y=100)
        var custom_ad_view := AdView.new(unit_id, ad_size, AdPosition.custom(0, 100))
        ```

    === "C#"

        ```csharp
        // 预定义位置
        var adView = new AdView(unitId, adSize, AdPosition.Top);

        // 自定义坐标 (例如 x=0, y=100)
        var customAdView = new AdView(unitId, adSize, AdPosition.Custom(0, 100));
        ```

---

### 中介广告生态变更

对广告中介（Mediation）系统进行了清理和升级。已弃用的中介广告商已被移除，同时新增了对几种主流广告网络的支持。

#### 移除的中介网络
由于弃用或兼容性原因，移除了以下旧版中介适配器：

* AdColony

#### 新增的中介网络
新引入了对以下中介广告网络的支持：

* AppLovin
* BidMachine
* Chartboost
* DT Exchange
* i-mobile
* InMobi
* IronSource
* LINE
* Unity Ads

---

### 新增广告格式

版本 5.0.0 添加了对两种全新广告格式的一等公民支持：

1. **开屏广告 (App Open Ads):** 当用户打开或切回应用时展示的广告。使用 [`AppOpenAdLoader`](reference/classes/AppOpenAdLoader.md) 加载，通过 [`AppOpenAd`](reference/classes/AppOpenAd.md) 控制。
2. **原生模板覆盖广告 (Native Overlay Ads):** 允许使用原生模板（Small 或 Medium 布局）并结合样式配置 ([`NativeTemplateStyle`](reference/classes/NativeTemplateStyle.md), [`NativeAdOptions`](reference/classes/NativeAdOptions.md)) 直接在游戏画面上方渲染可自定义的原生广告。

---

### 新增全局设置与隐私合规功能

[`MobileAds`](reference/classes/MobileAds.md) 类和 [`UserMessagingPlatform`](reference/classes/UserMessagingPlatform.md) 库中新增了若干 API 方法以支持用户同意、隐私合规和调试：

* **广告检查器 (Ad Inspector):** 通过 [`MobileAds`](reference/classes/MobileAds.md).`open_ad_inspector(ad_inspector_closed_listener)` 打开广告检查器界面。
* **第一方 ID 选项:** 使用 [`MobileAds`](reference/classes/MobileAds.md).`set_publisher_first_party_id_enabled(enabled)` 开启或关闭发布商第一方 ID。
* **同意 Cookie 偏好:** 使用 [`MobileAds`](reference/classes/MobileAds.md).`set_gad_has_consent_for_cookies(enabled)` 配置 SDK 是否获得了 Cookie 授权，并可通过 `get_gad_has_consent_for_cookies()` 查询。
* **禁用崩溃报告 (仅 iOS):** 使用 [`MobileAds`](reference/classes/MobileAds.md).`disable_sdk_crash_reporting()` 来阻止 Mobile Ads SDK 收集并转发崩溃日志。
* **UMP 隐私选择窗口:** 使用 [`UserMessagingPlatform`](reference/classes/UserMessagingPlatform.md).`show_privacy_options_form(on_privacy_options_form_dismissed)` 按需显示隐私设置界面，并使用 [`ConsentInformation`](reference/classes/ConsentInformation.md).`get_privacy_options_requirement_status()` 获取当前状态。

---

### 统一使用项目设置 (Project Settings) 进行配置

在 5.0.0 版本中，插件已将所有配置选项统一合并到了 Godot 原生的 **项目设置** (Project Settings) 的 `admob/` 分类下。这替代了旧版中使用的任何自定义编辑器弹窗或配置文件。

!!! warning "配置流程重大破坏性变更：config.gd 已被移除"
    在 v4 版本中，Android 的 AdMob App ID 是通过直接修改 `res://addons/admob/android/config.gd` 文件中的静态变量来设置的。
    
    在 v5 版本中，**`config.gd` 已经被彻底移除**。你必须将现有的 App ID 搬迁到项目设置中的新位置。

配置项现在已注册并可在 **Project Settings > General** 下进行配置：

* **Android 设置:** `admob/general/android/enabled`、`admob/general/android/app_id` 以及各类初始化/加载优化标志。
* **iOS 设置:** `admob/general/ios/enabled` 和 `admob/general/ios/app_id`。
* **中介网络开关:** 所有中介合作伙伴可以直接在 `admob/mediation/` 下通过布尔型标志开启或关闭（例如 `admob/mediation/applovin`、`admob/mediation/meta` 等）。

![General Settings](assets/general_settings.png)
![Mediation Settings](assets/mediation_settings.png)

---

### 无头模式动态二进制安装程序 (CI/CD)

为了支持在 headless 持续集成 (CI) 环境中正常构建，同时避免在 Git 仓库中打包巨大的原生二进制文件，v5.0.0 包含了一个同步下载工具：
* 当在无头环境（如 GitHub Actions）下运行时，插件会在启动时自动检测是否缺失 Android/iOS 目标平台的二进制依赖。
* 若缺失，它会自动并动态地从官方发布版本 (Releases) 中下载并解压对应的二进制文件。
