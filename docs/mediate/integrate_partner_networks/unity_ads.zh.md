# 通过中介集成 Unity Ads

本指南介绍了如何使用 Google Mobile Ads SDK，通过[中介](../get_started.md)从 Unity Ads 加载和展示广告。它提供了有关如何将 Unity Ads 集成到 Godot 应用的中介配置，以及如何将 Unity Ads SDK 和适配器集成到 Godot 应用的说明。

本文档基于：

- [Google Mobile Ads SDK Android 文档 (英文)](https://developers.google.com/admob/android/mediation/unity)
- [Google Mobile Ads SDK iOS 文档 (英文)](https://developers.google.com/admob/ios/mediation/unity)

## 支持的集成和广告格式

Unity Ads 的 AdMob 中介适配器具有以下功能：

| 集成 |   |
|-------------|---|
| 出价 (Bidding) | ✅ |
| 瀑布流 (Waterfall) | ✅ |

| 格式 | |
|-----------------------|------------|
| 横幅广告 (Banner) | ✅ |
| 插屏广告 (Interstitial) | ✅ |
| 激励广告 (Rewarded) | ✅ |
| 激励插屏广告 | ✅ |

## 先决条件
- 完成[入门指南](../../index.md)
- 完成[中介入门指南](../get_started.md)

## 第 1 步：设置 Unity Ads
建议按照 [Android](https://developers.google.com/admob/android/mediation/unity#step_1_set_up_unity_ads) 或 [iOS](https://developers.google.com/admob/ios/mediation/unity#step_1_set_up_unity_ads) 的教程进行操作，两者的操作步骤相同。

## 第 2 步：配置 AdMob 广告单元的中介设置
建议按照 [Android](https://developers.google.com/admob/android/mediation/unity#step_2) 或 [iOS](https://developers.google.com/admob/ios/mediation/unity#step_2) 的教程进行操作，两者的操作步骤相同。

## 第 3 步：导入 Unity Ads SDK 插件

=== "Android"
    1. 下载 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 版插件。
    2. 解压 `.zip` 文件。在其中，您会发现一个 `unity_ads` 文件夹。
    3. 将 `unity_ads` 文件夹的内容复制并粘贴到 `res://addons/admob/android/bin/` 下的 Android 插件文件夹中。

=== "iOS"
    Unity Ads 适配器**已包含**在标准 iOS 插件下载中。如果您按照 [iOS 安装指南](../../index.md#download-install)进行操作，您的 `res://ios/plugins/` 目录中应该已经有了必要的文件（`poing-godot-admob-unity_ads.gdip` 和相关框架）。

## 第 4 步：启用插件

=== "Android"
    请务必在**项目设置**（在 `Admob > Android > Mediation > Unity Ads` 下）中启用 **Unity Ads**。

=== "iOS"
    请务必在 **iOS 导出预设**的插件列表中勾选 `Ad Mob` 和 `Ad Mob Unity Ads`（并在 Plists 配置中输入您的 AdMob 应用 ID）。

## 第 5 步：额外设置

### 欧盟用户同意政策
要将同意信息传递给 Unity Ads SDK，请使用以下代码：

=== "GDScript"

    ```gdscript
    UnityAds.set_consent(true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetConsent(true);
    ```

### 隐私同意
要设置隐私同意（例如针对 CCPA），请使用以下代码：

=== "GDScript"

    ```gdscript
    UnityAds.set_privacy_consent("user_privacy_data", true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetPrivacyConsent("user_privacy_data", true);
    ```
