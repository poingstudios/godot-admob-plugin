# 在中介中集成 i-mobile

本指南介绍如何使用 Google Mobile Ads SDK 通过[中介](../get_started.md)加载并展示来自 i-mobile 的广告。它提供了关于如何将 i-mobile 集成到 Godot 应用的中介配置中，以及如何集成 i-mobile SDK 和适配器的说明。

本文档基于：

- [Google Mobile Ads SDK Android 文档（英文）](https://developers.google.com/admob/android/mediation/imobile)
- [Google Mobile Ads SDK iOS 文档（英文）](https://developers.google.com/admob/ios/mediation/imobile)

## 支持的集成和广告格式

i-mobile 的 AdMob 中介适配器具有以下能力：

| 集成 |   |
|-------------|---|
| 出价 (Bidding) |   |
| 中介历史记录/瀑布流 (Waterfall) | ✅ |

| 广告格式 |            |
|-----------------------|------------|
| 横幅广告 (Banner) | ✅          |
| 插屏广告 (Interstitial) | ✅          |
| 激励广告 (Rewarded) |            |
| 激励插屏广告 |            |
| 原生广告 (Native) |            |

## 前提条件
- 完成[开始使用](../../index.md)指南
- 完成中介[开始使用](../get_started.md)指南

## 步骤 1：设置 i-mobile
我们建议参考 [Android](https://developers.google.com/admob/android/mediation/imobile#step_1_set_up_i-mobile) 或 [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_1_set_up_i-mobile) 的官方教程进行设置，两端的设置流程相同。

## 步骤 2：为您的 AdMob 广告单元配置中介设置
我们建议参考 [Android](https://developers.google.com/admob/android/mediation/imobile#step_2) 或 [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_2) 的官方教程进行配置，两端的配置流程相同。

## 步骤 3：导入 i-mobile SDK 插件

=== "Android"
    1. 下载适用于 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 的插件。
    2. 解压 `.zip` 文件。在解压出来的内容中，您会找到一个 `imobile` 文件夹。
    3. 复制 `imobile` 文件夹的内容并将其粘贴到 Android 插件文件夹中，路径为 `res://addons/admob/android/bin/`。

=== "iOS"
    i-mobile 适配器**已包含**在标准 iOS 插件的下载中。如果您已经按照 [iOS 安装指南](../../index.md#download-install)操作，您的 `res://ios/plugins/` 目录中应该已经有了所需的文件（`poing-godot-admob-imobile.gdip` 及相关的 framework）。

## 步骤 4：启用插件

=== "Android"
    确保在**项目设置**（位于 `Admob > Android > Mediation > Imobile`）中启用 **Imobile**。

=== "iOS"
    确保在您的 **iOS 导出预设**的插件列表中勾选 `Ad Mob` 和 `Ad Mob iMobile`（并在 Plists 配置中输入您的 AdMob 应用 ID）。

## 步骤 5：可选步骤（法规设置）
i-mobile 不需要通过 Google Mobile Ads 适配器 API 额外编写自定义代码来配置 GDPR 或 CCPA。同意和隐私设置可直接通过 AdMob 控制台进行配置，或使用平台层级的其他方案进行管理。
