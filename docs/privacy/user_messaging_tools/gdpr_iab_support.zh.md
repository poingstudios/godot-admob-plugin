# 向欧洲经济区用户披露信息

根据 Google 的 [EU 地区用户意见征求政策](https://www.google.com/about/company/user-consent-policy/)，您必须向欧洲经济区 (EEA)、英国和瑞士的用户进行某些披露，并在法律要求的情况下征得他们同意使用 Cookie 或其他本地存储，以及使用个人数据（例如广告 ID）投放广告。该政策反映了欧盟《电子隐私指令》和《通用数据保护条例》(GDPR) 的要求。

本指南概述了作为 UMP SDK 的一部分支持 GDPR IAB TCF v2 消息所需的步骤。它旨在与[入门指南](get_started.md)结合使用，该指南概述了如何使用 UMP SDK 运行您的应用以及设置消息的基础知识。以下指南专门针对 GDPR IAB TCF v2 消息。如需了解更多信息，请参阅 [IAB 要求对欧盟用户意见征求消息的影响](https://support.google.com/admob/answer/10207733)。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/privacy/gdpr)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/privacy/gdpr)

## 前提条件

- 完成[入门指南](get_started.md)。
- 创建[面向应用的欧洲法规消息](https://support.google.com/admob/answer/10113207)。

## 撤消同意授权

GDPR 要求支持[撤消同意授权](https://support.google.com/admob/answer/10113915)，以允许用户随时撤消其同意选择。请参阅[隐私选项](get_started.md)以实现让用户撤消其同意选择的方法。

## 标记为未达到同意年龄的用户

要指明用户是否未达到同意年龄，请设置 `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA)。将 TFUA 设置为 `true` 时，UMP SDK 不会向用户请求同意授权。如果您的应用拥有混合受众群体，请针对儿童用户设置此参数以确保不会请求同意授权。

!!! warning "重要提示"
    UMP SDK 不会将针对意见征求请求设置的 TFUA 标记转发给 Mobile Ads SDK。您必须显式地在广告请求配置中设置 `tag_for_under_age_of_consent`。如果您没有在广告请求中设置 `tag_for_under_age_of_consent`，UMP SDK 将不会收集任何允许 Google 确定未达到同意年龄的用户是否正在使用您的应用的信息。

    如需了解更多信息，请参阅[为未达到同意年龄的用户标记广告请求](../../advanced_topics/targeting.md)。

以下示例展示了在 UMP 同意请求中将 TFUA 设置为 `true`：

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
        // 指明用户未达到同意年龄。
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## 在 AdMob 中介中设置同意授权

要在 AdMob 中介中设置同意授权，请完成以下各部分中的步骤。

### 在 GDPR 消息中添加广告合作伙伴

按照[在已发布的 GDPR 消息中添加广告合作伙伴](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages)中的步骤，将您的中介合作伙伴添加到广告合作伙伴列表中。否则可能会导致合作伙伴无法在您的应用上投放广告。

下表列出了每个广告来源的广告技术合作伙伴名称：

| 广告来源 | 广告技术合作伙伴名称 |
| --- | --- |
| AppLovin | AppLovin Corp. |
| BidMachine | BidMachine |
| BIGO Ads SDK | Empathy Technology Pte.Ltd. (BIGO Ads) |
| Chartboost | Chartboost |
| DT Exchange | DT Exchange (Fyber Monetization) |
| i-mobile | i-mobile |
| InMobi | InMobi |
| ironSource Ads | ironSource Mobile |
| Liftoff Monetize | Liftoff |
| LY Ads Network | LY Ads Network |
| maio | maio |
| Meta Audience Network | Meta |
| Mintegral | Mobvista/Mintegral |
| Moloco Ads SDK | Moloco Ads |
| myTarget | Mail.ru |
| Pangle | Pangle DSP |
| PubMatic OpenWrap SDK | PubMatic |
| Unity Ads | Unity Ads |
| Verve HyBid SDK | Verve Group |

### 向广告来源转发同意授权

下表显示了哪些广告来源支持将来自已集成 IAB 透明度与同意框架 (TCF) 以及 [Google 附加同意技术规范](https://support.google.com/admob/answer/9681999) 的同意管理平台的 GDPR 同意信号传递给广告来源的 SDK：

| 广告来源 | 支持的最低版本 |
| --- | --- |
| AppLovin | 7.0.0 |
| BidMachine | 1.0.0 |
| BIGO Ads SDK | 1.0.0 |
| Chartboost | 4.14.0 |
| DT Exchange | 3.3.0 |
| i-mobile | 不适用¹ |
| InMobi | 4.6.4 |
| ironSource Ads | 2.6.0 |
| Liftoff Monetize | 5.2.2 |
| LY Ads Network | 不适用¹ |
| maio | 不适用¹ |
| Meta Audience Network | 不适用² |
| Mintegral | 2.2.3 |
| Moloco Ads SDK | 1.0.0 |
| myTarget | 3.40.0 |
| Pangle | 5.9.0 |
| PubMatic OpenWrap SDK | 1.0.0 |
| Unity Ads | 3.20.0 |

¹ *广告来源不针对欧洲经济区流量投放广告。*  
² *如需了解详情，请与您的 Meta 合作伙伴经理联系。*

## 如何读取用户选择的同意授权

收集 GDPR 同意授权后，您可以根据 [TCF v2 规范](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details)从本地存储中读取用户选择的同意授权。

`IABTCF_PurposeConsents` 键用于指明针对各项 [TCF 用途](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/#Appendix_A_Purposes_Features_and_Special_Purposes_Definitions)的同意授权。您可以使用 [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md) 读取和写入应用程序首选项。

以下代码段展示了如何检查针对用途 1 的同意授权：

=== "GDScript"

    ```gdscript
    # 示例值："1111111111"
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents")

    # 用途从零开始编制索引。索引 0 包含关于用途 1 的信息。
    if not purpose_consents.is_empty():
        var purpose_one_string := purpose_consents[0]
        var has_consent_for_purpose_one := purpose_one_string == "1"
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;

    // 示例值："1111111111"
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents");

    // 用途从零开始编制索引。索引 0 包含关于用途 1 的信息。
    if (!string.IsNullOrEmpty(purposeConsents))
    {
        char purposeOneString = purposeConsents[0];
        bool hasConsentForPurposeOne = purposeOneString == '1';
    }
    ```

## 常见问题解答

!!! note
    请参阅[欧洲法规消息常见问题解答](https://support.google.com/admob/answer/13554116)了解更多常见问题解答。

**如果不采取任何措施来满足在 EEA、英国和瑞士投放广告的意见征求管理平台要求，会发生什么情况？**

自 2024 年 1 月 16 日起，如果合作伙伴未采用 [Google 认证的 CMP](https://support.google.com/admob/answer/13554116)，则只有[受限广告](https://support.google.com/admob/answer/9882911)符合在 EEA 和英国流量上投放的条件。请确保准备好已认证的 CMP，以确保变现不受影响。

**如何检查用户是否同意？**

同意授权不是由单个位表示的，而是由 IAB TCF 规范中定义的一组用途和供应商表示的。有关 Google 广告个性化标准，请参阅[同意政策：个性化和非个性化广告](https://support.google.com/admanager/answer/9012903)。

此外，未在 TCF 供应商列表中注册的 Google [广告技术提供商](https://support.google.com/admob/answer/9012903) (ATP) 列表中的广告技术使用 [Google 的附加同意技术规范](https://support.google.com/admob/answer/9681999)收集同意授权。Google 在 [additional-consent-providers.csv](https://storage.googleapis.com/tcfac/additional-consent-providers.csv) 中发布这些提供商名单及其 ID。

要调试单个广告请求，请使用广告检查器中的[排查隐私设置问题](../../advanced_topics/ad_inspector/troubleshoot_privacy.md)功能查看在广告请求中传递的以下隐私信号：

| 广告检查器标签 | 广告请求查询参数 | 含义 |
| --- | --- | --- |
| GDPR 适用 (`IABTCF_gdprApplies`) | `gdpr` | GDPR 是否适用于此广告请求。 |
| TC 字符串 (`IABTCF_TCString`) | `gdpr_consent` | TC 字符串。IAB 提供了一个 Web 工具，您可以手动解码该值。 |
| AC 字符串 (`IABTCF_AddtlConsent`) | `addtl_consent` | 来自 Google 附加同意技术规范的 AC 字符串。 |

如需通过程序读取同意选择，请参阅[如何读取用户选择的同意授权](#_7)。

**我是否需要使用 Google 的 UMP SDK 才能满足 CMP 要求？**

不需要，您可以使用 [Google 认证的 CMP 列表](https://support.google.com/admob/answer/13554116)中的任何 CMP 来投放广告。

**即使用户已经同意，如何使用 UMP SDK 再次显示意见征求表单？**

如果用户已经做出同意决定，Google 的意见征求管理解决方案将不会请求收集新意见，直到 TC 字符串过期或变为无效。

GDPR 要求允许用户随时撤消其同意选择。请参阅[隐私选项](get_started.md)了解实现撤消方法。要再次显示表单，请调用 `UserMessagingPlatform.show_privacy_options_form()` (`UserMessagingPlatform.ShowPrivacyOptionsForm()`)。

**我集成了经过 Google 认证的 CMP，但即使来自已同意的用户，我也没有看到向中介合作伙伴发出任何广告请求。为什么会发生这种情况？**

在 TCF 下，Google 会检查广告技术提供商和其他程序化需求来源是否不违反 Google 政策，并且在将它们纳入中介瀑布流之前至少拥有一项处理数据的法律依据。如需了解详情，请转到[在 AdMob 中介中设置同意授权](#admob)部分。

使用第三方 CMP 时，请确认第三方 CMP 支持存储 ACString，并将每个中介合作伙伴包含在第三方 CMP 用于收集同意授权的广告技术提供商列表中。

**如果用户不同意，我可以更改应用的功能吗？政策是否允许？**

发布商可以在其应用中读取 IAB TCF 字符串。如需了解以编程方式读取同意选择的信息，请参阅[如何读取用户选择的同意授权](#_7)。发布商应与法律顾问一起审查相关法规下的义务。

**当我选择“管理选项”并同意所有用途时，我看不到任何广告？为什么会这样？**

除了收集用途同意之外，您还需要收集供应商同意。任何供应商（例如 Google）都需要获得用途同意和供应商同意才能投放适当的广告。

**向同一用户同时展示 iOS ATT 提示和 GDPR 同意的最佳做法是什么？**

我们建议在用户同意 GDPR 的情况下先显示 GDPR 意见征求消息，然后再显示 iOS ATT 提示。如果您在 AdMob 界面中配置了这两条消息，UMP SDK 会自动处理。有关更多信息，请参阅[您的用户将看到哪条消息](https://support.google.com/admob/answer/10115027)。

如果您没有使用 UMP SDK 显示 ATT 提示，我们建议您在收集到 GDPR 同意后读取同意选择，以确定是否显示 iOS ATT 提示。

**如何为已经同意第 1 版的用户实现 AC 字符串第 2 版？**

根据 [Google 的附加同意技术规范](https://support.google.com/admob/answer/9681999)检查本地存储中的 `IABTCF_AddtlConsent` 键，以确定用户是否已同意第 2 版 AC 字符串，以及是否需要再次显示表单：

=== "GDScript"

    ```gdscript
    # 示例值："2~1.35.41.101~dv.9.21.81"
    var additional_consent := ApplicationPreferences.get_string("IABTCF_AddtlConsent")

    # 索引 0 包含关于规范版本号的信息。
    if not additional_consent.is_empty():
        var spec_ac_version := additional_consent[0]
        var is_ac_version_2 := spec_ac_version == "2"
    ```

=== "C#"

    ```csharp
    // 示例值："2~1.35.41.101~dv.9.21.81"
    string additionalConsent = ApplicationPreferences.GetString("IABTCF_AddtlConsent");

    // 索引 0 包含关于规范版本号的信息。
    if (!string.IsNullOrEmpty(additionalConsent))
    {
        char specACVersion = additionalConsent[0];
        bool isACVersion2 = specACVersion == '2';
    }
    ```
