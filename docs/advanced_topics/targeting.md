# Targeting
This guide explains how to provide targeting information to an ad request. 

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/targeting)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/targeting)

## Prerequisites
- Complete the [Get started guide](../README.md)


## RequestConfiguration

`RequestConfiguration` is an entity used to gather targeting details that can be globally applied through a static method within `MobileAds`. And is applied by `MobileAds.set_request_configuration(request_configuration)`

### Child-directed setting
To comply with [Children's Online Privacy Protection Act (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy), you can set the "tag for child-directed treatment" option. This signifies that you want your content to be treated as child-directed for COPPA purposes. It's important to ensure that you have the authority to make this decision on behalf of the app owner. Please be aware that misusing this setting can lead to the termination of your Google account.

As an app developer, you can indicate whether your content is child-directed when making ad requests. When you specify that your content is child-directed, Google will take steps to disable Interest-Based Advertising (IBA) and remarketing ads for that particular ad request.

To implement this setting, you can use `RequestConfiguration.new().tag_for_child_directed_treatment = int` with the following options:

- Use `tag_for_child_directed_treatment` with `RequestConfiguration.TagForChildDirectedTreatment.TRUE` to indicate that your content should be treated as child-directed for COPPA compliance. This will prevent the transmission of the Android advertising identifier (AAID). This will prevent the transmission of the Advertising Identifier, IDFA.

- Use `tag_for_child_directed_treatment` with `RequestConfiguration.TagForChildDirectedTreatment.FALSE` to specify that your content should not be treated as child-directed for COPPA purposes.

- Use `tag_for_child_directed_treatment` with `RequestConfiguration.TagForChildDirectedTreatment.UNSPECIFIED` if you do not want to specify how your content should be treated in ad requests with respect to COPPA.

The following example indicates that you want your content treated as child-directed for purposes of COPPA:

```gdscript
var request_configuration := RequestConfiguration.new()
request_configuration.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
MobileAds.set_request_configuration(request_configuration)
```

### Users under the age of consent

You can configure your ad requests to receive treatment for users in the European Economic Area (EEA) who are below the age of consent. This feature is designed to assist with compliance under the [General Data Protection Regulation (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679). It's important to note that GDPR may impose additional legal obligations, so it's advisable to consult with legal counsel and review the European Union's guidelines. Google's tools are meant to support compliance but do not replace publishers' legal responsibilities. [Learn more about how the GDPR affects publishers](https://support.google.com/admob/answer/7666366).

When using this feature, an ad request will contain a "Tag For Users under the Age of Consent in Europe" (TFUA) parameter. This parameter deactivates personalized advertising, including remarketing, for all ad requests. It also prevents requests to third-party ad vendors like ad measurement pixels and third-party ad servers.

Similar to the child-directed settings, you can utilize the property in `RequestConfiguration.new()` class to set the TFUA parameter: `tag_for_under_age_of_consent = int`. It offers the following options:

- Use `tag_for_under_age_of_consent` with `RequestConfiguration.TagForUnderAgeOfConsent.TRUE` to indicate that you want the ad request to receive treatment for users in the European Economic Area (EEA) under the age of consent. This will also prevent the transmission of the Android advertising identifier (AAID). This will also prevent the transmission of the Advertising Identifier, IDFA.

- Use `tag_for_under_age_of_consent` with `RequestConfiguration.TagForUnderAgeOfConsent.FALSE` to specify that you do not want the ad request to receive treatment for users in the European Economic Area (EEA) under the age of consent.

- Use `tag_for_under_age_of_consent` with `RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED` to indicate that you have not specified whether the ad request should receive treatment for users in the European Economic Area (EEA) under the age of consent.

Here's an example indicating your intention to include TFUA in your ad requests:

```gdscript
var request_configuration := RequestConfiguration.new()
request_configuration.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED
MobileAds.set_request_configuration(request_configuration)
```

The tags to enable the [Child-directed setting](#child-directed-setting) and `tag_for_under_age_of_consent` property should not both simultaneously be set to `true`. If they are, the child-directed setting takes precedence.


### Ad content filtering

To ensure compliance with Google Play's [Inappropriate Ads Policy](https://support.google.com/googleplay/android-developer/answer/9857753#zippy=%2Cexamples-of-common-violations), which encompasses associated offers within ads, it's essential that all ads and their associated offers displayed in your app align with your app's [content rating](https://support.google.com/googleplay/android-developer/answer/9898843). This applies even if the content itself complies with Google Play's policies.

Tools like the maximum ad content rating provide you with greater control over the content of ads shown to your users. You can set a maximum content rating to ensure adherence to platform policies.

Apps can specify a maximum ad content rating for their ad requests using the `max_ad_content_rating` property. AdMob ads returned with this configuration will have a content rating that matches or falls below the specified level. The available values for this network extra are based on [digital content label classifications](https://support.google.com/admob/answer/7562142) and must be one of the following strings:

- `RequestConfiguration.MAX_AD_CONTENT_RATING_G`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_PG`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_T`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_MA`

The following code demonstrates how to configure a `RequestConfiguration` object to specify that ad content returned should not exceed a digital content label designation of `G`:

```gdscript
var request_configuration := RequestConfiguration.new()
request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
MobileAds.set_request_configuration(request_configuration)
```

Learn more about:

- [Setting the maximum content rating for each ad request](https://support.google.com/admob/answer/10477886)
- [Setting the maximum ad content rating for an app or account](https://support.google.com/admob/answer/7562142)

