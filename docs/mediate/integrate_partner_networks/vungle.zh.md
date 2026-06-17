# 通过中介集成 Liftoff Monetize (Vungle)

!!! info

    **注**：Vungle 现已更名为 Liftoff Monetize。

本指南介绍如何使用 Google Mobile Ads SDK 通过[中介](../get_started.zh.md)加载并展示来自 Liftoff Monetize 的广告，内容涵盖竞价（bidding）和瀑布流（waterfall）集成。它提供了关于将 Liftoff Monetize 集成到 Godot 应用的中介配置中，以及将 Vungle SDK 和适配器集成到您的 Godot 应用中的说明。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/mediation/liftoff-monetize)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/mediation/liftoff-monetize)

## 支持的集成和广告格式

Vungle 的 AdMob 中介适配器具有以下功能：

| 集成方式 |   |
|-------------|---|
| 竞价 (Bidding)     | ✅ |
| 瀑布流 (Waterfall)   | ✅ |

| 广告格式               |            |
|-----------------------|------------|
| 横幅广告 (Banner)                | [^1]       |
| 插页式广告 (Interstitial)          | ✅          |
| 激励广告 (Rewarded)              | ✅          |
| 插页式激励广告 (Rewarded Interstitial) | [^1], [^2] |

[^1]: 竞价中不支持此格式（仅在瀑布流中介中支持）。
[^2]: 如需访问此格式，请联系您的 Liftoff Monetize 客户经理。

## 前提条件
- 完成[入门指南](../../index.zh.md)
- 完成中介[入门指南](../get_started.zh.md)


## 限制

- Liftoff Monetize 不支持使用相同的广告位参考 ID（Placement Reference ID）加载多个广告。
    - 如果该广告位已有另一个请求正在加载或等待显示，Vungle 适配器将正常返回第二个请求失败。
- Liftoff Monetize 仅支持每次加载 1 个横幅广告。
    - 如果已经加载了横幅广告，Vungle 适配器将正常返回后续的横幅广告请求失败。

## 第 1 步：设置 Liftoff Monetize
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize) 或 [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize) 的教程，因为两者的步骤是相同的。

## 第 2 步：为您的 AdMob 广告单元配置中介设置
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_2) 或 [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_2) 的教程，因为两者的步骤是相同的。

## 第 3 步：导入 Vungle SDK 插件

=== "Android"
    1. 下载适用于 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 的插件。
    2. 解压 `.zip` 文件。在里面，您会找到一个 `vungle` 文件夹。
    3. 复制 `vungle` 文件夹的内容，并将其粘贴到 Android 插件文件夹 `res://addons/admob/android/bin/` 中。
    ![android-vungle](../../assets/android/vungle.png)

=== "iOS"
    Liftoff Monetize (Vungle) 适配器**已包含**在标准的 iOS 插件下载中。如果您遵循了 [iOS 安装指南](../../index.md#download-install)，您应该已经在 `res://ios/plugins/` 目录中拥有所需的文件（`poing-godot-admob-vungle.gdip` 及相关框架）。

## 第 4 步：启用插件

=== "Android"
    请确保在**项目设置**（位于 `Admob > Android > Mediation > Vungle` 下）中启用了 **Vungle**。

=== "iOS"
    请确保在 **iOS 导出预设**的插件列表中勾选了 `Ad Mob` 和 `Ad Mob vungle`（并在 Plists 配置中输入了您的 AdMob App ID）。

    ![ios-vungle-export](../../assets/ios/vungle-export.png)

## 第 5 步：需要添加的其他代码

Liftoff Monetize 要求将您将在 Godot 应用中使用的所有广告位列表传达给其 SDK。您可以使用 `VungleInterstitialMediationExtras` 和 `VungleRewardedVideoMediationExtras`（此处使用 `VungleRewardedMediationExtras`）类将此广告位列表提供给适配器。以下代码示例展示了如何使用这些类。

=== "插页式广告 (Interstitial)"

    === "GDScript"
    
        ```gdscript
        var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
    
        if OS.get_name() == "iOS":
            vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
        elif OS.get_name() == "Android":
            vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    
        var ad_request := AdRequest.new()
        ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleInterstitialMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```
=== "激励广告 (Rewarded)"

    === "GDScript"
    
        ```gdscript
    	var vungle_mediation_extras := VungleRewardedMediationExtras.new()
    	
    	if OS.get_name() == "iOS":
    		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
    	elif OS.get_name() == "Android":
    		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    	
    	var ad_request := AdRequest.new()
    	ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleRewardedMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```

---

=== "Android"
    集成 Liftoff Monetize 无需添加其他代码。

=== "iOS"
    **SKAdNetwork 集成**

    遵循 [Liftoff Monetize 的文档](https://support.vungle.com/hc/en-us/articles/360002925791-Integrate-Vungle-SDK-for-iOS#h_01EM0AZYJ84W7CWZHW4KRHQHXF) 将 SKAdNetwork 标识符添加到您项目的 `Info.plist` 文件中。

## 第 6 步：测试您的实现
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_5_test_your_implementation) 或 [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_5_test_your_implementation) 的教程，因为两者的步骤是相同的。

## 可选步骤

!!! info

    **重要提示**：请确保您拥有 **帐号管理** 权限，以完成欧盟用户同意和 GDPR、CCPA 以及用户消息平台的配置。要了解更多信息，请参阅以下[新用户角色](https://support.google.com/admob/answer/2784628)文章。


### 欧盟用户同意和 GDPR
根据 Google 的[欧盟地区用户同意策略](https://www.google.com/about/company/consentstaging.html)，您必须向欧洲经济区 (EEA) 的用户进行某些披露，并就使用设备标识符和个人数据征得他们的同意。该政策符合欧盟电子隐私指令 (ePrivacy Directive) 和通用数据保护条例 (GDPR)。在征求同意时，您必须明确指出中介链中可能收集、接收或使用个人数据的每个广告网络。此外，您还应该提供有关每个网络打算如何使用这些数据的信息。重要的是，Google 目前无法自动将用户的同意选择传输给这些网络。

以下示例代码展示了如何将此同意信息传递给 Vungle SDK。如果您选择调用此方法，建议在通过 Google Mobile Ads SDK 请求广告之前进行调用。

=== "GDScript"

    ```gdscript
    Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "1.0.0")
    ```

=== "C#"

    ```csharp
    Vungle.UpdateConsentStatus(Vungle.Consent.OptedIn, "1.0.0");
    ```

有关更多详细信息以及该方法中可以提供的值，请参阅 [GDPR 推荐的实现说明](https://support.vungle.com/hc/en-us/articles/360047780372#gdpr-recommended-implementation-instructions-0-1)。

#### 将 Liftoff 添加到 GDPR 广告合作伙伴列表中
遵循 [GDPR 设置](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) 中的步骤，在 AdMob UI 中将 Liftoff 添加到 GDPR 广告合作伙伴列表中。

### CCPA
[加州消费者隐私法案 (CCPA)](https://support.google.com/admob/answer/9561022) 规定，加州州内居民有权选择退出其“个人信息”的“销售”（根据法律定义）。该选择退出选项应通过销售方主页上醒目的“勿出售我的个人信息”（Do Not Sell My Personal Information）链接展示。

[CCPA 准备](../../privacy/regulatory_solutions/us_states_privacy_laws.md) 指南提供了一项为 Google 广告投放启用[限制性数据处理](https://privacy.google.com/businesses/rdp/) 的功能。然而，Google 无法将此设置应用到您中介链中的每个广告网络。因此，您必须识别中介链中可能涉及个人信息销售的每个广告网络，并遵循这些网络提供的特定指南，以确保符合 CCPA。

以下示例代码展示了如何将该同意信息传递给 Vungle SDK。如果您选择调用该方法，建议在通过 Google Mobile Ads SDK 请求广告之前进行调用。

=== "GDScript"

    ```gdscript
    Vungle.update_ccpa_status(Vungle.Consent.OPTED_IN)
    ```

=== "C#"

    ```csharp
    Vungle.UpdateCcpaStatus(Vungle.Consent.OptedIn);
    ```

#### 将 Liftoff 添加到 CCPA 广告合作伙伴列表中
遵循 [CCPA 设置](https://support.google.com/admob/answer/10860309) 中的步骤，在 AdMob UI 中将 Liftoff 添加到 CCPA 广告合作伙伴列表中。

### 网络特定参数
适用于 Godot 的 Vungle 适配器支持一个额外的请求参数，可以根据您实现的广告格式，使用 `VungleRewardedMediationExtras` 或 `VungleInterstitialMediationExtras` 类将其传递给适配器。这些类包含以下属性：

- `sound_enabled`：确定播放视频广告时是否应启用声音。

- `user_id`：表示 Godot 的 Liftoff Monetize 集成的激励用户 ID 字符串。

- `all_placements`：包含应用内所有广告位 ID 的数组（对于使用 Vungle SDK 6.2.0 或更高版本的应用，不需要此属性）。

对于 iOS，您可以简单地使用 `VungleAdNetworkExtras` 类。

以下是关于如何创建设置了这些参数的广告请求的代码示例：

=== "插页式广告 (Interstitial)"

    === "GDScript"
    
        ```gdscript
    	var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
    	
    	if OS.get_name() == "iOS":
    		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
    		vungle_mediation_extras.sound_enabled = true
    		vungle_mediation_extras.user_id = "ios_user_id"
    	elif OS.get_name() == "Android":
    		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    		vungle_mediation_extras.sound_enabled = true
    		vungle_mediation_extras.user_id = "android_user_id"
    	
    	var ad_request := AdRequest.new()
    	ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleInterstitialMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "ios_user_id";
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "android_user_id";
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```
=== "激励广告 (Rewarded)"

    === "GDScript"
    
        ```gdscript
        var vungle_mediation_extras := VungleRewardedMediationExtras.new()
    
        if OS.get_name() == "iOS":
            vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
            vungle_mediation_extras.sound_enabled = true
            vungle_mediation_extras.user_id = "ios_user_id"
        elif OS.get_name() == "Android":
            vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
            vungle_mediation_extras.sound_enabled = true
            vungle_mediation_extras.user_id = "android_user_id"
    
        var ad_request := AdRequest.new()
        ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleRewardedMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "ios_user_id";
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "android_user_id";
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```


## 错误代码
如果适配器未能从 Audience Network 接收广告，发布商可以使用以下类下的 `ResponseInfo` 来检查广告响应中的底层错误：

=== "Android"
    | 广告格式       | 类名                                     |
    |--------------|------------------------------------------------|
    | 横幅广告 (Banner)       | com.vungle.mediation.VungleInterstitialAdapter |
    | 插页式广告 (Interstitial) | com.vungle.mediation.VungleInterstitialAdapter |
    | 激励广告 (Rewarded)     | com.vungle.mediation.VungleAdapter             |

=== "iOS"
    | 广告格式       | 类名                          |
    |--------------|-------------------------------------|
    | 横幅广告 (Banner)       | GADMAdapterVungleInterstitial       |
    | 插页式广告 (Interstitial) | GADMAdapterVungleInterstitial       |
    | 激励广告 (Rewarded)     | GADMAdapterVungleRewardBasedVideoAd |

以下是当广告加载失败时，Liftoff Monetize 适配器抛出的错误代码和随附消息：

=== "Android"
    | 错误代码 | 域名                          | 原因                                                                                                         |
    |------------|---------------------------------|----------------------------------------------------------------------------------------------------------------|
    | 0-100      | com.vungle.warren               | Vungle SDK 返回了错误。请参阅[文档](https://support.vungle.com/hc/en-us/articles/360047780372-Advanced-Settings#exception-codes-for-debugging-0-9)获取更多详细信息。 |
    | 101        | com.google.ads.mediation.vungle | 服务器参数无效（例如，app ID 或 placement ID）。                                                       |
    | 102        | com.google.ads.mediation.vungle | 请求的横幅广告尺寸无法映射到有效的 Liftoff Monetize 广告尺寸。                                    |
    | 103        | com.google.ads.mediation.vungle | Liftoff Monetize 需要 Activity 上下文来请求广告。                                                  |
    | 104        | com.google.ads.mediation.vungle | Vungle SDK 无法为相同的广告位 ID 加载多个广告。                                             |
    | 105        | com.google.ads.mediation.vungle | Vungle SDK 初始化失败。                                                                           |
    | 106        | com.google.ads.mediation.vungle | Vungle SDK 返回了成功加载的回调，但 Banners.getBanner() 或 Vungle.getNativeAd() 返回了 null。 |
    | 107        | com.google.ads.mediation.vungle | Vungle SDK 未准备好播放该广告。                                                                        |

=== "iOS"
    | 错误代码 | 域名                      | 原因                                                                                                                |
    |------------|-----------------------------|-----------------------------------------------------------------------------------------------------------------------|
    | 1-100      | Vungle SDK 发送          | Vungle SDK 返回了错误。请参阅[代码](https://github.com/Vungle/iOS-SDK/blob/6.12.0/VungleSDK.xcframework/ios-arm64_armv7/VungleSDK.framework/Headers/VungleSDK.h)获取更多详细信息。 |
    | 101        | com.google.mediation.vungle | 在 AdMob UI 中配置的 Liftoff Monetize 服务器参数缺失/无效。                                    |
    | 102        | com.google.mediation.vungle | 此网络配置已加载了一个广告。Vungle SDK 无法为同一个广告位 ID 加载第二个广告。 |
    | 103        | com.google.mediation.vungle | 请求的广告尺寸与 Liftoff Monetize 支持的横幅广告尺寸不匹配。                                        |
    | 104        | com.google.mediation.vungle | Vungle SDK 无法渲染该横幅广告。                                                                            |
    | 105        | com.google.mediation.vungle | 无论广告位 ID 如何，Vungle SDK 每次仅支持加载 1 个横幅广告。                                   |
    | 106        | com.google.mediation.vungle | Vungle SDK 发送了一个回调，说明该广告不可播放。                                                             |
