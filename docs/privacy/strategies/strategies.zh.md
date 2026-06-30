# 隐私策略

!!! note
    **重要**：请验证您拥有**帐户管理**权限以完成隐私策略配置。要了解更多信息，请参阅[新的用户角色](https://support.google.com/admob/answer/278428)文章。

本指南介绍了 Google Mobile Ads SDK 中可用的隐私策略，帮助您在尊重用户隐私的同时投放更相关的广告。

本文档基于：

- [Google Mobile Ads SDK for Android - 隐私策略](https://developers.google.com/admob/android/privacy/strategies)
- [Google Mobile Ads SDK for iOS - 隐私策略](https://developers.google.com/admob/ios/privacy/strategies)

## 发布商第一方 ID

Google Mobile Ads SDK 引入了发布商第一方 ID，帮助您使用从应用收集的数据投放更相关和个性化的广告。

发布商第一方 ID 默认启用，但您可以使用以下方法将其禁用。

=== "GDScript"

    ```gdscript
    # 禁用发布商第一方 ID。
    MobileAds.set_publisher_first_party_id_enabled(false)
    ```

=== "C#"

    ```csharp
    // 禁用发布商第一方 ID。
    MobileAds.SetPublisherFirstPartyIDEnabled(false);
    ```


