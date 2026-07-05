# 通过中介集成 IronSource

本指南介绍如何使用 Google Mobile Ads SDK 通过[中介](../get_started.zh.md)加载并展示来自 IronSource 的广告。它提供了关于将 IronSource 集成到 Godot 应用的中介配置中，以及将 IronSource SDK 和适配器集成到您的 Godot 应用中的说明。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/mediation/ironsource)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/mediation/ironsource)

## 支持的集成和广告格式

IronSource 的 AdMob 中介适配器具有以下功能：

| 集成方式 |   |
|-------------|---|
| 竞价 (Bidding)     | ✅ |
| 瀑布流 (Waterfall)   | ✅ |

| 广告格式               |            |
|-----------------------|------------|
| 横幅广告 (Banner)                | ✅          |
| 插页式广告 (Interstitial)          | ✅          |
| 激励广告 (Rewarded)              | ✅          |
| 插页式激励广告 (Rewarded Interstitial) | ✅ [^1]    |
| 原生广告 (Native)                |            |

[^1]: 此格式仅在瀑布流集成中受支持。

## 前提条件
- 完成[入门指南](../../index.zh.md)
- 完成中介[入门指南](../get_started.zh.md)

## 第 1 步：设置 IronSource
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/ironsource#step_1_set_up_ironsource) 或 [iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_1_set_up_ironsource) 的教程，因为两者的步骤是相同的。

## 第 2 步：为您的 AdMob 广告单元配置中介设置
我们建议遵循 [Android](https://developers.google.com/admob/android/mediation/ironsource#step_2) 或 [iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_2) 的教程，因为两者的步骤是相同的。

## 第 3 步：导入 IronSource SDK 插件

=== "Android"
    1. 下载适用于 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 的插件。
    2. 解压 `.zip` 文件。在里面，您会找到一个 `ironsource` 文件夹。
    3. 复制 `ironsource` 文件夹的内容，并将其粘贴到 Android 插件文件夹 `res://addons/admob/android/bin/` 中。

=== "iOS"
    IronSource 适配器**已包含**在标准的 iOS 插件 download 中。如果您遵循了 [iOS 安装指南](../../index.md#download-install)，您应该已经在 `res://ios/plugins/` 目录中拥有所需的文件（`poing-godot-admob-ironsource.gdip` 及相关框架）。

## 第 4 步：启用插件

=== "Android"
    请确保在**项目设置**（位于 `Admob > Android > Mediation > Ironsource` 下）中启用了 **IronSource**。

=== "iOS"
    请确保在 **iOS 导出预设**的插件列表中勾选了 `Ad Mob` 和 `Ad Mob Iron Source`（并在 Plists 配置中输入了您的 AdMob App ID）。

## 第 5 步：可选步骤（监管设置）

### 欧盟用户同意和 GDPR
根据 Google 的[欧盟地区用户同意策略](https://www.google.com/about/company/consentstaging.html)，您必须向欧洲经济区 (EEA) 的用户进行某些披露，并就使用 Cookie 或其他本地存储以及使用个人数据征得他们的同意。

要将 GDPR 同意信息传递给 IronSource SDK，请使用以下代码：

=== "GDScript"

    ```gdscript
    IronSource.set_consent(true)
    ```

=== "C#"

    ```csharp
    IronSource.SetConsent(true);
    ```

### CCPA
为了遵守 CCPA，您可以设置元数据（metadata）设置。以下示例代码显示了如何将此信息传递给 IronSource SDK：

=== "GDScript"

    ```gdscript
    IronSource.set_metadata("do_not_sell", "false")
    ```

=== "C#"

    ```csharp
    IronSource.SetMetaData("do_not_sell", "false");
    ```

### 用户 ID
要为激励广告集成设置 IronSource 用户 ID，请使用以下代码：

=== "GDScript"

    ```gdscript
    IronSource.set_user_id("unique_user_id_123")
    ```

=== "C#"

    ```csharp
    IronSource.SetUserId("unique_user_id_123");
    ```
