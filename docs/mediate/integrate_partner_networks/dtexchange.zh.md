# 在中介中集成 DT Exchange

本指南介绍如何使用 Google Mobile Ads SDK 通过[中介](../get_started.md)加载并展示来自 DT Exchange（前身为 Fyber）的广告。它提供了关于如何将 DT Exchange 集成到 Godot 应用的中介配置中，以及如何集成 DT Exchange SDK 和适配器的说明。

本文档基于：

- [Google Mobile Ads SDK Android 文档（英文）](https://developers.google.com/admob/android/mediation/dt-exchange)
- [Google Mobile Ads SDK iOS 文档（英文）](https://developers.google.com/admob/ios/mediation/dt-exchange)

## 支持的集成和广告格式

DT Exchange 的 AdMob 中介适配器具有以下能力：

| 集成 |   |
|-------------|---|
| 出价 (Bidding) | ✅ |
| 中介历史记录/瀑布流 (Waterfall) | ✅ |

| 广告格式 |            |
|-----------------------|------------|
| 横幅广告 (Banner) | ✅          |
| 插屏广告 (Interstitial) | ✅          |
| 激励广告 (Rewarded) | ✅          |
| 激励插屏广告 |            |
| 原生广告 (Native) |            |

## 前提条件
- 完成[开始使用](../../index.md)指南
- 完成中介[开始使用](../get_started.md)指南

## 步骤 1：设置 DT Exchange
我们建议参考 [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_1_set_up_dt_exchange) 或 [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_1_set_up_dt_exchange) 的官方教程进行设置，两端的设置流程相同。

## 步骤 2：为您的 AdMob 广告单元配置中介设置
我们建议参考 [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_2) 或 [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_2) 的官方教程进行配置，两端的配置流程相同。

## 步骤 3：导入 DT Exchange SDK 插件

=== "Android"
    1. 下载适用于 [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 的插件。
    2. 解压 `.zip` 文件。在解压出来的内容中，您会找到一个 `dtexchange` 文件夹。
    3. 复制 `dtexchange` 文件夹的内容并将其粘贴到 Android 插件文件夹中，路径为 `res://addons/admob/android/bin/`。

=== "iOS"
    DT Exchange 适配器**已包含**在标准 iOS 插件的下载中。如果您已经按照 [iOS 安装指南](../../index.md#download-install)操作，您的 `res://ios/plugins/` 目录中应该已经有了所需的文件（`poing-godot-admob-dtexchange.gdip` 及相关的 framework）。

## 步骤 4：启用插件

=== "Android"
    确保在**项目设置**（位于 `Admob > Android > Mediation > Dtexchange`）中启用 **Dtexchange**。

=== "iOS"
    确保在您的 **iOS 导出预设**的插件列表中勾选 `Ad Mob` 和 `Ad Mob Dt Exchange`（并在 Plists 配置中输入您的 AdMob 应用 ID）。

## 步骤 5：可选步骤（法规设置）

### GDPR 同意
DT Exchange 允许通过布尔值同意标记或 IAB 同意字符串将 GDPR 同意选项传递给其 SDK。

要传递布尔值 GDPR 同意，请使用以下代码：

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent(true)
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsent(true);
    ```

要传递 GDPR IAB 同意字符串，请使用以下代码：

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent_string("your_iab_consent_string")
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsentString("your_iab_consent_string");
    ```

### CCPA（美国州隐私字符串）
为了符合 CCPA，您可以设置 IAB 美国隐私字符串。以下示例代码显示了如何将此信息传递给 DT Exchange SDK：

=== "GDScript"

    ```gdscript
    DTExchange.set_ccpa_string("1---")
    ```

=== "C#"

    ```csharp
    DTExchange.SetCCPAString("1---");
    ```
