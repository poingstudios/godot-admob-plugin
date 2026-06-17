# 通过竞价集成 Meta Audience Network

!!! info

    **重要提示**：Facebook Audience Network 现已更名为 Meta Audience Network。请参阅 [Meta 的声明](https://about.fb.com/news/2021/10/facebook-company-is-now-meta/)以获取更多信息。

本指南介绍如何使用 Google Mobile Ads SDK 通过[中介](../get_started.zh.md)加载并展示来自 Meta Audience Network 的广告，重点介绍竞价（bidding）集成。它提供了关于将 Meta Audience Network 集成到 Godot 应用的中介配置中，以及将 Meta Audience Network SDK 和适配器集成到您的 Godot 应用中的说明。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/mediation/meta)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/mediation/meta)

## 支持的集成和广告格式

Meta Audience Network 的 AdMob 中介适配器具有以下功能：

| 集成方式 |   |
|-------------|---|
| 竞价 (Bidding)     | ✅ |
| 瀑布流 (Waterfall) [^1]   | ❌ |

| 广告格式               |   |
|--------------|---|
| 横幅广告 (Banner)       | ✅ |
| 插页式广告 (Interstitial) | ✅ |
| 激励广告 (Rewarded)     | ✅ |

[^1]: Meta Audience Network 在 2021 年起已转为[仅支持竞价](https://www.facebook.com/audiencenetwork/resources/blog/audience-network-to-become-bidding-only-beginning-with-ios-in-2021)。

## 前提条件
- 完成[入门指南](../../index.zh.md)
- 完成中介[入门指南](../get_started.zh.md)

## 第 1 步：设置 Meta Audience Network
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/meta#setup) 或 [iOS](https://developers.google.com/admob/ios/mediation/meta#setup) 的教程，因为两者的步骤是相同的。

## 第 2 步：为您的 AdMob 广告单元配置中介设置
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/meta#configure_mediation) 或 [iOS](https://developers.google.com/admob/ios/mediation/meta#configure_mediation) 的教程，因为两者的步骤是相同的。

## 第 3 步：导入 Meta Audience Network 插件

=== "Android"
    1. 下载适用于 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 的插件。
    2. 解压 `.zip` 文件。在里面，您会找到一个 `meta` 文件夹。
    3. 复制 `meta` 文件夹的内容，并将其粘贴到 Android 插件文件夹 `res://addons/admob/android/bin/` 中。
    ![android-meta](../../assets/android/meta.png)

=== "iOS"
    Meta Audience Network 适配器**已包含**在标准的 iOS 插件下载中。如果您遵循了 [iOS 安装指南](../../index.md#download-install)，您应该已经在 `res://ios/plugins/` 目录中拥有所需的文件（`poing-godot-admob-meta.gdip` 及相关框架）。

## 第 4 步：启用插件

=== "Android"
    请确保在**项目设置**（位于 `Admob > Android > Mediation > Meta` 下）中启用了 **Meta**。

=== "iOS"
    请确保在 **iOS 导出预设**的插件列表中勾选了 `Ad Mob` 和 `Ad Mob Meta`（并在 Plists 配置中输入了您的 AdMob App ID）。

    ![ios-meta-export](../../assets/ios/meta-export.png)

## 第 5 步：需要添加的其他代码

=== "Android"
    集成 Meta Audience Network 无需添加其他代码。

=== "iOS"
    **SKAdNetwork 集成**

    遵循 [Meta Audience Network 官方文档](https://developers.facebook.com/docs/setting-up/platform-setup/ios/SKAdNetwork) 将 SKAdNetwork 标识符添加到您的项目的 `Info.plist` 文件中。

    ---
    **编译错误**

    您必须按照以下步骤将 Swift 路径添加到您 Target 的 Build Settings 中，以防止编译错误。

    将以下路径添加到 Target 的 **Build Settings** 下的 **Library Search Paths** 中：

    ```
    $(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)
    $(SDKROOT)/usr/lib/swift
    ```

    将以下路径添加到 Target 的 **Build Settings** 下的 **Runpath Search Paths** 中：
    ```
    /usr/lib/swift
    ```

    阅读更多关于：https://developers.google.com/admob/ios/mediation/meta#step_4_additional_code_required

    ---
    **启用广告跟踪 (Advertising tracking enabled)**

    如果您针对 iOS 14 或更高版本进行开发，Meta Audience Network 要求您使用以下代码显式设置其 [Advertising Tracking Enabled](https://developers.facebook.com/docs/audience-network/setting-up/platform-setup/ios/advertising-tracking-enabled) 标志：

    !!! info

        **重要提示**：您需要在初始化 Mobile Ads SDK 之前设置此标志。

=== "GDScript"

    ```gdscript
    if OS.get_name() == "iOS":
        # FBAdSettings 仅在 iOS 上可用，Google 并没有在 Android SDK 中提供该方法
        FBAdSettings.set_advertiser_tracking_enabled(true)
    ```

=== "C#"

    ```csharp
    if (OS.GetName() == "iOS")
    {
        // FBAdSettings 仅在 iOS 上可用，Google 并没有在 Android SDK 中提供该方法
        FBAdSettings.SetAdvertiserTrackingEnabled(true);
    }
    ```

## 第 6 步：测试您的实现
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/meta#step_5_test_your_implementation) 或 [iOS](https://developers.google.com/admob/ios/mediation/meta#step_5_test_your_implementation) 的教程，因为两者的步骤是相同的。


## 可选步骤

!!! info

    **重要提示**：请确保您拥有 **帐号管理** 权限，以完成欧盟用户同意和 GDPR、CCPA 以及用户消息平台的配置。要了解更多信息，请参阅以下[新用户角色](https://support.google.com/admob/answer/2784628)文章。


### 欧盟用户同意和 GDPR
根据 Google 的[欧盟地区用户同意策略](https://www.google.com/about/company/consentstaging.html)，您必须向欧洲经济区 (EEA) 的用户进行某些披露，并就使用设备标识符和个人数据征得他们的同意。该政策符合欧盟电子隐私指令 (ePrivacy Directive) 和通用数据保护条例 (GDPR)。在征求同意时，您必须明确指出中介链中可能收集、接收或使用个人数据的每个广告网络。此外，您还应该提供有关每个网络打算如何使用这些数据的信息。重要的是，Google 目前无法自动将用户的同意选择传输给这些网络。

请参阅 Meta 的[指南](https://www.facebook.com/business/gdpr)以获取有关 GDPR 和 Meta 广告的信息。

#### 将 Facebook 添加到 GDPR 广告合作伙伴列表中
遵循 [GDPR 设置](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) 中的步骤，在 AdMob UI 中将 **Facebook** 添加到 GDPR 广告合作伙伴列表中。


### CCPA
[加州消费者隐私法案 (CCPA)](https://support.google.com/admob/answer/9561022) 规定，加州州内居民有权选择退出其“个人信息”的“销售”（根据法律定义）。该选择退出选项应通过销售方主页上醒目的“勿出售我的个人信息”（Do Not Sell My Personal Information）链接展示。

[CCPA 准备](../../privacy/regulatory_solutions/us_states_privacy_laws.md) 指南提供了一项为 Google 广告投放启用[限制性数据处理](https://privacy.google.com/businesses/rdp/) 的功能。然而，Google 无法将此设置应用到您中介链中的每个广告网络。因此，您必须识别中介链中可能涉及个人信息销售的每个广告网络，并遵循这些网络提供的特定指南，以确保符合 CCPA。

请参阅 Meta 的[文档](https://developers.facebook.com/docs/marketing-apis/data-processing-options)以了解加州用户的数据处理选项。

#### 将 Facebook 添加到 CCPA 广告合作伙伴列表中
遵循 [CCPA 设置](https://support.google.com/admob/answer/10860309) 中的步骤，在 AdMob UI 中将 **Facebook** 添加到 CCPA 广告合作伙伴列表中。

### 缓存

=== "Android"
    **Android 9**:

    从 Android 9（API 级别 28）开始，[默认禁用明文支持](https://developer.android.com/training/articles/security-config#CleartextTrafficPermitted)，这将影响 Meta Audience Network SDK 的媒体缓存功能，并可能影响用户体验和广告收入。请遵循 [Meta 的文档](https://developers.facebook.com/docs/audience-network/android-network-security-config/) 来更新您应用中的网络安全配置。

=== "iOS"
    不适用。

## 错误代码
如果适配器未能从 Audience Network 接收广告，发布商可以使用以下类下的 `ResponseInfo` 来检查广告响应中的底层错误：

=== "Android"
    ```
    com.google.ads.mediation.facebook.FacebookAdapter
    com.google.ads.mediation.facebook.FacebookMediationAdapter
    ```

=== "iOS"
    ```
    GADMAdapterFacebook
    GADMediationAdapterFacebook
    ```

以下是当广告加载失败时，Meta Audience Network 适配器抛出的错误代码和随附消息：

=== "Android"
    | 错误代码 | 原因                                                                                                   |
    |------------|----------------------------------------------------------------------------------------------------------|
    | 101        | 服务器参数无效（例如，缺少 Placement ID）。                                                   |
    | 102        | 请求的广告尺寸与 Meta Audience Network 支持的横幅广告尺寸不匹配。                      |
    | 103        | 发布商必须使用 **Activity** 上下文请求广告。                                             |
    | 104        | Meta Audience Network SDK 初始化失败。                                                      |
    | 105        | 发布商未请求统一原生广告。                                                    |
    | 106        | 加载的原生广告是与预期不同的对象。                                        |
    | 107        | 使用的 **Context** 对象无效。                                                                  |
    | 108        | 加载的广告缺少必需的原生广告素材。                                                  |
    | 109        | 无法从竞价 payload 中创建原生广告。                                                       |
    | 110        | Meta Audience Network SDK 无法展示其插页式/激励广告。                          |
    | 111        | 创建 Meta Audience Network **AdView** 对象时抛出异常。                                |
    | 1000-9999  | Meta Audience Network 返回了 SDK 特定的错误。有关更多详细信息，请参阅 Meta Audience Network 的[文档](https://developers.facebook.com/docs/audience-network/setting-up/test/checklist-errors)。 |

=== "iOS"
    | 错误代码 | 原因                                                                                                                |
    |------------|-----------------------------------------------------------------------------------------------------------------------|
    | 101        | 服务器参数无效（例如，缺少 Placement ID）。                                                                |
    | 102        | 请求的广告尺寸与 Meta Audience Network 支持的横幅广告尺寸不匹配。                                   |
    | 103        | Meta Audience Network 广告对象初始化失败。                                                             |
    | 104        | Meta Audience Network SDK 无法展示其插页式/激励广告。                                       |
    | 105        | 横幅广告的根视图控制器 (Root view controller) 为 **nil**。                                                                     |
    | 106        | Meta Audience Network SDK 初始化失败。                                                                   |
    | 1000-9999  | Meta Audience Network 返回了 SDK 特定的错误。有关更多详细信息，请参阅 Meta Audience Network 的[文档](https://developers.facebook.com/docs/audience-network/setting-up/test/checklist-errors)。 |
