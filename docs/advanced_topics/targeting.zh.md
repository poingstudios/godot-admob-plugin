# 定向（Targeting）
本指南介绍如何向广告请求提供定向信息。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/targeting)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/targeting)

## 前提条件
- 完成[入门指南](../index.zh.md)


## RequestConfiguration

`RequestConfiguration` 是用于收集定向详细信息的实体，可以通过 `MobileAds` 内的静态方法进行全局应用。并且通过 `MobileAds.set_request_configuration(request_configuration)` 来应用。

### 面向儿童的设置 (Child-directed setting) {: #child-directed-setting }
为了遵守[儿童在线隐私保护法案 (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy)，您可以设置“面向儿童的评估标志”选项。这表示您希望根据 COPPA 的要求将您的内容视为面向儿童的内容。请务必确保您有权代表应用所有者做出此决定。请注意，滥用此设置可能会导致您的 Google 帐号被终止。

作为应用开发者，您可以在进行广告请求时指示您的内容是否面向儿童。当您指定您的内容面向儿童时，Google 将采取步骤禁用该特定广告请求的兴趣个性化广告 (IBA) 和再营销广告。

要实现此设置，您可以使用 `RequestConfiguration.new().tag_for_child_directed_treatment = int`，包含以下选项：

- 使用 `tag_for_child_directed_treatment` 配以 `RequestConfiguration.TagForChildDirectedTreatment.TRUE` 来指示您的内容应被视为面向儿童，以符合 COPPA。这将阻止传输 Android 广告标识符 (AAID)。同时也将阻止传输 iOS 广告标识符 (IDFA)。

- 使用 `tag_for_child_directed_treatment` 配以 `RequestConfiguration.TagForChildDirectedTreatment.FALSE` 来指定您的内容不应被视为面向儿童，以符合 COPPA。

- 使用 `tag_for_child_directed_treatment` 配以 `RequestConfiguration.TagForChildDirectedTreatment.UNSPECIFIED`，如果您不想在广告请求中指定您的内容在 COPPA 方面的评估方式。

以下示例指示您希望根据 COPPA 的要求将您的内容视为面向儿童：

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.ChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatment.True;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

### 未达到同意年龄的用户 (Users under the age of consent)

您可以配置您的广告请求，以针对欧洲经济区 (EEA) 内未达到同意年龄的用户进行处理。此功能旨在协助遵守[通用数据保护条例 (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679)。需要注意的是，GDPR 可能会施加其他法律义务，因此建议咨询法律顾问并审查欧盟的指南。Google 的工具旨在支持合规性，但不能取代发布商的法律责任。[了解更多关于 GDPR 如何影响发布商的信息](https://support.google.com/admob/answer/7666366)。

使用此功能时，广告请求将包含“欧洲未达到同意年龄的用户标志”（TFUA）参数。此参数会停用所有广告请求的个性化广告（包括再营销）。它还会阻止向第三方广告提供商（如广告测量像素和第三方广告服务器）发送请求。

类似于面向儿童的设置，您可以使用 `RequestConfiguration` 类中的属性来设置 TFUA 参数：`tag_for_under_age_of_consent = int`。它提供以下选项：

- 使用 `tag_for_under_age_of_consent` 配以 `RequestConfiguration.TagForUnderAgeOfConsent.TRUE` 来指示您希望针对欧洲经济区 (EEA) 内未达到同意年龄的用户处理该广告请求。这也会阻止传输 Android 广告标识符 (AAID)。同时也将阻止传输 iOS 广告标识符 (IDFA)。

- 使用 `tag_for_under_age_of_consent` 配以 `RequestConfiguration.TagForUnderAgeOfConsent.FALSE` 来指定您不希望针对欧洲经济区 (EEA) 内未达到同意年龄的用户处理该广告请求。

- 使用 `tag_for_under_age_of_consent` 配以 `RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED` 来指示您尚未指定是否应针对欧洲经济区 (EEA) 内未达到同意年龄的用户处理该广告请求。

以下是一个指示您打算在广告请求中包含 TFUA 的示例：

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.UnderAgeOfConsent = RequestConfiguration.TagForUnderAgeOfConsent.Unspecified;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

不应将启用[面向儿童的设置](#child-directed-setting)的标志和 `tag_for_under_age_of_consent` 属性同时设置为 `true`。如果同时设置，面向儿童的设置将具有更高优先级。


### 广告内容过滤 (Ad content filtering)

为了确保符合 Google Play 的[不当广告政策](https://support.google.com/googleplay/android-developer/answer/9857753#zippy=%2Cexamples-of-common-violations)（其中包括广告内关联的优惠），显示在您应用中的所有广告及其关联的优惠必须与您的应用的[内容分级](https://support.google.com/googleplay/android-developer/answer/9898843)相一致。即使内容本身符合 Google Play 的政策，这也同样适用。

像最高广告内容分级（maximum ad content rating）这样的工具可以为您提供对向用户展示的广告内容的更大控制权。您可以设置最高内容分级以确保遵守平台政策。

应用可以使用 `max_ad_content_rating` 属性为其广告请求指定最高广告内容分级。返回的带有此配置的 AdMob 广告，其内容分级将符合或低于指定级别。此参数的可用值基于[数字内容标签分类](https://support.google.com/admob/answer/7562142)，且必须是以下字符串之一：

- `RequestConfiguration.MAX_AD_CONTENT_RATING_G`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_PG`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_T`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_MA`

以下代码演示了如何配置 `RequestConfiguration` 对象，以指定返回的广告内容不应超过数字内容标签 `G` 的限制：

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.MaxAdContentRating = RequestConfiguration.MaxAdContentRatingG;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

了解更多关于：

- [为每次广告请求设置最高内容分级](https://support.google.com/admob/answer/10477886)
- [为应用或帐号设置最高广告内容分级](https://support.google.com/admob/answer/7562142)
