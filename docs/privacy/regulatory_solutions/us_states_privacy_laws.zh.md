# 美国各州隐私法合规性

!!! note

    **重要提示**：请确保您拥有 **帐号管理** 权限，以完成欧盟用户同意和 GDPR、CCPA 以及用户消息平台的配置。要了解更多信息，请参阅以下[新用户角色](https://support.google.com/admob/answer/2784628)文章。

为了帮助发布商遵守[美国各州隐私法](https://support.google.com/admob/answer/9561022)，Google Mobile Ads SDK 允许发布商使用两个不同的参数来指示 Google 是否应启用[限制性数据处理 (RDP)](https://business.safety.google/rdp/)。SDK 为发布商提供了使用以下信号在广告请求级别设置 RDP 的能力：

- Google 的 RDP
- [IAB 定义的](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf) `IABUSPrivacy_String`

当使用其中任一参数时，Google 将限制其使用在向发布商提供服务时处理的某些唯一标识符和其他数据。因此，Google 将仅展示非个性化广告。这些参数将覆盖 UI 中的 RDP 设置。

发布商应自行决定限制性数据处理如何支持其合规计划以及何时应启用它。可以同时使用这两个可选参数，尽管它们对 Google 的广告投放具有相同的效果。

本指南旨在帮助发布商了解在每次广告请求的基础上启用这些选项所需的步骤。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/privacy/us-states)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/privacy/us-states)

## RDP 信号

要通知 Google 应使用 Google 的信号启用 RDP，请插入键 `rdp` 作为附加参数，其值为 `1`。

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

    **提示**：您可以使用网络跟踪或诸如 [Charles](https://www.charlesproxy.com/) 之类的代理工具来捕获您应用的 HTTPS 流量，并检查广告请求中的 **&rdp=** 参数。

## IAB 信号

要通知 Google 应使用 IAB 的信号启用 RDP，请插入键 `IABUSPrivacy_String` 作为附加参数。请确保您使用的字符串值符合 [IAB 规范](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf)。

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["IABUSPrivacy_String"] = "IAB_STRING"
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("IABUSPrivacy_String", "IAB_STRING");
    ```

!!! note

    **提示**：您可以使用网络跟踪或诸如 [Charles](https://www.charlesproxy.com/) 之类的代理工具来捕获您应用的 HTTPS 流量，并检查广告请求中的 **&us_privacy=** 参数。

## 中介

!!! note

    **重要提示**：请确保您拥有所需的中介配置权限。这些权限包括访问广告资源管理、应用访问权限以及隐私和消息设置。要了解更多信息，请参阅以下[新用户角色](https://support.google.com/admob/answer/2784628)文章。

如果您使用[中介](../../mediate/get_started.zh.md)，请按照 [CPRA 设置](https://support.google.com/admob/answer/10860309)中的步骤，在 AdMob UI 中将您的中介合作伙伴添加到 CCPA 广告合作伙伴列表中。此外，请咨询每个广告网络合作伙伴的文档，以确定他们提供哪些选项来帮助实现 CCPA 合规性。
