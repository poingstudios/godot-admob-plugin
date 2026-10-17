# 向美国用户披露信息

!!! note
    **重要提示：** 请确认您拥有 **帐号管理** 权限，以完成欧盟用户同意和 GDPR、美国各州法规以及用户消息平台的配置。有关详细信息，请参阅[管理用户对您帐号的访问权限](https://support.google.com/admob/answer/2784628)。

为了帮助您遵守[美国各州隐私法](https://support.google.com/admob/answer/9561022)，Google Mobile Ads SDK 允许您使用 Google 的[受限数据处理 (RDP)](https://business.safety.google/rdp/) 参数来指明是否启用 RDP。Google 还针对适用的美国各州支持[全球隐私平台 (GPP)](https://iabtechlab.com/standards/global-privacy-platform-gpp/)。

当 Google Mobile Ads SDK 使用任一信号时，SDK 会限制某些唯一标识符的使用以及在向您提供服务时处理的其他数据。

您必须自行决定受限数据处理如何支持您的合规计划以及何时启用它。确定是直接使用 RDP 参数还是使用 GPP 规范传递同意和隐私选择信号。

本指南可帮助您通过本地存储全局启用 RDP 或按广告请求启用 RDP，并使用 GPP 信号。

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/privacy/us-states)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/privacy/us-states)

## 前提条件

- 完成[入门指南](../user_messaging_tools/get_started.md)。
- 创建[针对应用的美国各州法规消息](https://support.google.com/admob/answer/13467025)。

## 针对未达到法定承诺年龄的用户进行标记

若要指明用户未达到法定承诺年龄，请设置 `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA)。将 TFUA 设置为 `true` 时，UMP SDK 不会向用户请求同意。如果您的应用面向混合受众，请为儿童用户设置此参数，以确保不会请求同意。

!!! warning "重要提示"
    UMP SDK 不会将同意请求上设置的 TFUA 标记转发给 Mobile Ads SDK。您必须在广告请求中明确设置 `tag_for_under_age_of_consent`。如果您没有在广告请求中设置 `tag_for_under_age_of_consent`，UMP SDK 将不会收集允许 Google 确定未达到法定承诺年龄的用户是否使用您的应用的任何信息。

    如需了解详情，请参阅[标记未达到法定承诺年龄的用户的广告请求](../../advanced_topics/targeting.md)。

以下示例在 UMP 同意请求中将 TFUA 设置为 `true`：

=== "GDScript"

    ```gdscript
    var params := ConsentRequestParameters.new()
    params.tag_for_under_age_of_consent = true

    UserMessagingPlatform.consent_information.update(params, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Core;

    var parameters = new ConsentRequestParameters
    {
        // 指明用户未达到法定承诺年龄。
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## 启用 RDP 信号

Google 支持两种启用受限数据处理 (RDP) 的方式。这两种方式均有效并受 Google Mobile Ads SDK 支持：

### 全局本地存储（推荐）

在官方 Android 和 iOS SDK 中，Google 建议直接将 `gad_rdp` 键写入本地存储（Android 上的 `SharedPreferences`，iOS 上的 `UserDefaults`）。Google Mobile Ads SDK 会在广告加载期间自动读取此键，并将 RDP 应用于整个应用的所有广告请求：

=== "GDScript"

    ```gdscript
    if OS.get_name() == "Android":
        ApplicationPreferences.set_int("gad_rdp", 1)
    elif OS.get_name() == "iOS":
        ApplicationPreferences.set_bool("gad_rdp", true)
    ```

=== "C#"

    ```csharp
    if (OperatingSystem.IsAndroid())
    {
        ApplicationPreferences.SetInt("gad_rdp", 1);
    }
    else if (OperatingSystem.IsIOS())
    {
        ApplicationPreferences.SetBool("gad_rdp", true);
    }
    ```

### 按广告请求

您还可以通过在 [`AdRequest`](../../reference/classes/AdRequest.md) 的 `extras` 字典中插入键 `rdp`，值为 `1`（在 C# 中为 `"1"`），按广告请求启用 RDP 信号：

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["rdp"] = 1
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("rdp", "1");
    ```

!!! note
    **提示：** 您可以使用网络跟踪或代理工具（如 [Charles](https://www.charlesproxy.com/)）捕获应用的 HTTPS 流量，并检查广告请求中的 **&rdp=** 参数。

## 使用 IAB GPP 信号

如果您使用意见征求管理平台 (CMP) 或您自己的自定义消息收集意见征求决定，Google Mobile Ads SDK 会遵循写入本地存储的 GPP 信号。用户消息平台 (UMP) SDK 支持写入 GPP 信号。要收集美国各州的同意，请在 AdMob 帐号的 **隐私权和投放消息** 下配置 **美国各州法规** 消息。有关 UMP 设置，请参阅[设置 UMP SDK](../user_messaging_tools/get_started.md)。

### 读取用户选择的同意授权

UMP SDK 根据 [IAB GPP 规范](https://iabtechlab.com/standards/global-privacy-platform-gpp/)将 GPP 数据写入本地存储。请注意，UMP SDK 仅填充这两个键来处理美国各州法规：

- `IABGPP_HDR_GppString`：包含已编码的用户同意和选择退出 (opt-out) 偏好的 GPP 字符串。
- `IABGPP_GppSID`：GPP 字符串中包含的部分 ID（例如，美国全国版为 `7`）。

您可以使用 [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md) 从本地存储中读取同意选择：

=== "GDScript"

    ```gdscript
    var gpp_string := ApplicationPreferences.get_string("IABGPP_HDR_GppString")
    var gpp_sid := ApplicationPreferences.get_string("IABGPP_GppSID")
    ```

=== "C#"

    ```csharp
    var gppString = ApplicationPreferences.GetString("IABGPP_HDR_GppString");
    var gppSid = ApplicationPreferences.GetString("IABGPP_GppSID");
    ```

## 测试您的美国各州法规消息

如需在测试设备上使用 UMP SDK 测试美国各州法规消息流程，请在 [`ConsentDebugSettings`](../../reference/classes/ConsentDebugSettings.md) 上强制设置调试地理位置：

- **模拟受法规管辖的美国州：** 将 `debug_geography` 设置为 `DebugGeography.Values.REGULATED_US_STATE`（在 C# 中为 `DebugGeography.RegulatedUsState`）。
- **禁止显示美国各州法规消息：** 将 `debug_geography` 设置为 `DebugGeography.Values.OTHER`（在 C# 中为 `DebugGeography.Other`）。

=== "GDScript"

    ```gdscript
    var request := ConsentRequestParameters.new()
    var debug_settings := ConsentDebugSettings.new()
    debug_settings.debug_geography = DebugGeography.Values.REGULATED_US_STATE
    debug_settings.test_device_hashed_ids.append("TEST-DEVICE-HASHED-ID")
    request.consent_debug_settings = debug_settings

    UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;

    var request = new ConsentRequestParameters();
    var debugSettings = new ConsentDebugSettings();
    debugSettings.DebugGeography = DebugGeography.RegulatedUsState;
    debugSettings.TestDeviceHashedIds.Add("TEST-DEVICE-HASHED-ID");
    request.ConsentDebugSettings = debugSettings;

    UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdated);
    ```

## 中介

如果您使用[中介](../../mediate/get_started.md)，请在 AdMob 界面中转到 **隐私权和投放消息** > **美国各州法规**，以管理美国各州的广告合作伙伴。请查阅每个广告网络合作伙伴的文档，确定他们为遵守美国各州法规提供的选项。
