# 通过中介集成 BidMachine

本指南介绍如何使用 Google Mobile Ads SDK 通过[中介](../get_started.zh.md)加载并展示来自 BidMachine 的广告。它提供了关于将 BidMachine 集成到 Godot 应用的中介配置中，以及将 BidMachine SDK 和适配器集成到您的 Godot 应用中的说明。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/mediation/bidmachine)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/mediation/bidmachine)

## 支持的集成和广告格式

BidMachine 的 AdMob 中介适配器具有以下功能：

| 集成方式 |   |
|-------------|---|
| 竞价 (Bidding)     | ✅ |
| 瀑布流 (Waterfall)   | ✅ |

| 广告格式               |            |
|-----------------------|------------|
| 横幅广告 (Banner)                | ✅          |
| 插页式广告 (Interstitial)          | ✅          |
| 激励广告 (Rewarded)              | ✅          |
| 插页式激励广告 (Rewarded Interstitial) |            |
| 原生广告 (Native)                |            |

## 前提条件
- 完成[入门指南](../../index.zh.md)
- 完成中介[入门指南](../get_started.zh.md)

## 第 1 步：设置 BidMachine
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/bidmachine#step_1_set_up_bidmachine) 或 [iOS](https://developers.google.com/admob/ios/mediation/bidmachine#step_1_set_up_bidmachine) 的教程，因为两者的步骤是相同的。

## 第 2 步：为您的 AdMob 广告单元配置中介设置
we recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/bidmachine#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/bidmachine#step_2)，as it will be the same for both.

## 第 3 步：导入 BidMachine SDK 插件

=== "Android"
    1. 下载适用于 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 的插件。
    2. 解压 `.zip` 文件。在里面，您会找到一个 `bidmachine` 文件夹。
    3. 复制 `bidmachine` 文件夹的内容，并将其粘贴到 Android 插件文件夹 `res://addons/admob/android/bin/` 中。

=== "iOS"
    BidMachine 适配器**已包含**在标准的 iOS 插件下载中。如果您遵循了 [iOS 安装指南](../../index.md#download-install)，您应该已经在 `res://ios/plugins/` 目录中拥有所需的文件（`poing-godot-admob-bidmachine.gdip` 及相关框架）。

## 第 4 步：启用插件

=== "Android"
    请确保在**项目设置**（位于 `Admob > Android > Mediation > Bidmachine` 下）中启用了 **Bidmachine**。

=== "iOS"
    请确保在 **iOS 导出预设**的插件列表中勾选了 `Ad Mob` 和 `Ad Mob Bid Machine`（并在 Plists 配置中输入了您的 AdMob App ID）。

## 第 5 步：可选步骤（监管设置）

### 欧盟用户同意和 GDPR
根据 Google 的[欧盟地区用户同意策略](https://www.google.com/about/company/consentstaging.html)，您必须向欧洲经济区 (EEA) 的用户进行某些披露，并就使用 Cookie 或其他本地存储以及使用个人数据征得他们的同意。

要将 GDPR 同意信息传递给 BidMachine SDK，请使用以下代码：

=== "GDScript"

    ```gdscript
    # 设置用户是否适用于 GDPR
    BidMachine.set_subject_to_gdpr(true)
    
    # 设置同意状态
    BidMachine.set_consent_status(true)
    ```

=== "C#"

    ```csharp
    // 设置用户是否适用于 GDPR
    BidMachine.SetSubjectToGdpr(true);
    
    // 设置同意状态
    BidMachine.SetConsentStatus(true);
    ```

### CCPA
为了遵守 CCPA，您可以设置美国隐私字符串（U.S. Privacy String）。以下示例代码显示了如何将此信息传递给 BidMachine SDK：

=== "GDScript"

    ```gdscript
    BidMachine.set_us_privacy_string("1YNN")
    ```

=== "C#"

    ```csharp
    BidMachine.SetUsPrivacyString("1YNN");
    ```
