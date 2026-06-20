# 在中介中集成 LINE Ads Network

本指南介绍如何使用 Google 移动广告 SDK 通过[中介](../get_started.md)加载和展示来自 LINE Ads Network (FiveAd) 的广告。它提供了关于如何将 LINE Ads Network 集成到 Godot 应用的中介配置中，以及如何集成 LINE Ads Network SDK 和适配器的说明。

本文档基于：

- [Google 移动广告 SDK Android 文档](https://developers.google.com/admob/android/mediation/line)
- [Google 移动广告 SDK iOS 文档](https://developers.google.com/admob/ios/mediation/line)

## 支持的集成和广告格式

适用于 LINE Ads Network 的 AdMob 中介适配器具有以下功能：

| 集成 |   |
|-------------|---|
| 出价 (Bidding)     | ✅ |
| 中介历史记录 (Waterfall)   | ✅ |

| 格式               |            |
|-----------------------|------------|
| 横幅广告 (Banner)                | ✅          |
| 插页广告 (Interstitial)          | ✅          |
| 激励广告 (Rewarded)              | ✅          |
| 激励插页广告 (Rewarded Interstitial) |            |
| 原生广告 (Native)                |            |

## 前提条件
- 完成[入门指南](../../index.md)
- 完成中介[入门指南](../get_started.md)

## 第 1 步：设置 LINE Ads Network
我们建议按照 [Android](https://developers.google.com/admob/android/mediation/line#step_1_set_up_line_ads_network) 或 [iOS](https://developers.google.com/admob/ios/mediation/line#step_1_set_up_line_ads_network) 的教程进行操作，因为这两个平台的操作是相同的。

## 第 2 步：配置 AdMob 广告单元的中介设置
我们建议按照 [Android](https://developers.google.com/admob/android/mediation/line#step_2) 或 [iOS](https://developers.google.com/admob/ios/mediation/line#step_2) 的教程进行操作，因为这两个平台的操作是相同的。

## 第 3 步：导入 LINE Ads Network SDK 插件

=== "Android"
    1. 下载适用于 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 的插件。
    2. 解压 `.zip` 文件。在其中，您将找到一个 `line` 文件夹。
    3. 复制 `line` 文件夹的内容并将其粘贴到 Android 插件文件夹中，路径为 `res://addons/admob/android/bin/`。

=== "iOS"
    LINE Ads Network 适配器已**包含**在标准 iOS 插件下载中。如果您按照 [iOS 安装指南](../../index.md#download-install)操作，您应该已经在 `res://ios/plugins/` 目录中拥有所需的文件 (`poing-godot-admob-line.gdip`)。

## 第 4 步：启用插件

=== "Android"
    确保在**项目设置**（在 `Admob > Android > Mediation > Line` 下）中启用 **Line**。

=== "iOS"
    确保在 **iOS 导出预设**的插件列表中勾选 `Ad Mob` 和 `Ad Mob Line`（并在 Plists 配置中输入您的 AdMob 应用 ID）。
