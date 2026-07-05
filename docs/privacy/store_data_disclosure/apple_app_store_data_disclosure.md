# Apple App Store data disclosure

Apple requires that developers publishing apps on the App Store disclose [certain information](https://developer.apple.com/app-store/app-privacy-details/) regarding their apps' data use. This guide explains the Google Mobile Ads SDK's data collection practices to make it easier for AdMob developers to answer the questions in App Store Connect.

!!! note
    **Important**: As the app developer, you are solely responsible for deciding how to respond to App Store Connect's privacy questions regarding your app's data collection and usage practices.

This document is based on:

- [Google Mobile Ads SDK iOS - App Store Data Disclosure](https://developers.google.com/admob/ios/privacy/data-disclosure)

## Data collected by the Google Mobile Ads SDK

To improve the performance of AdMob, the Google Mobile Ads SDK may collect certain information from apps, including:

| Data Type | Purpose |
|-----------|---------|
| **IP address** | May be used to estimate the general location of a device. |
| **Non-user related crash logs** | May be used to diagnose problems and improve the SDK. Diagnostic information may also be used for advertising and analytics purposes. |
| **User-associated performance data** | Such as app launch time, hang rate, or energy usage, which may be used to evaluate user behavior, understand the effectiveness of existing product features, and plan new features. Performance data may also be used for displaying ads, including sharing with other entities that display ads. |
| **A Device ID** | Such as the device's advertising identifier or other app- or developer-bounded device identifiers, which may be used for the purpose of third-party advertising and analytics. |
| **Advertising data** | Such as advertisements the user has seen, may be used to power analytics and advertising features. |
| **Other user product interactions** | Like app launch taps, and interaction information, like video views, may be used to improve advertising performance. |

All of the user data collected by the Google Mobile Ads SDK is encrypted in transit using the Transport Layer Security (TLS) protocol.

## Apple's privacy manifest files

Google Mobile Ads SDK version 11.2.0 and higher supports privacy manifest declarations. You are responsible for checking the privacy manifest and ensuring that your application's data disclosures are up to date.

Refer to [Apple documentation](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests) for details on interpreting a privacy report and their [enforcement update](https://developer.apple.com/news/?id=pvszzano) for app submission requirements.

## Additional data disclosures

If you are using any optional product features that involve additional data (such as advance reporting) or participating in any tests of new product features that involve additional data, be sure to check if those features or tests require additional data disclosures.

If you are using a prior version of the Google Mobile Ads SDK, consider updating to the latest version to ensure your app's disclosures are accurate. The Google Mobile Ads SDK will continue to be updated over time. Make sure to check back and update your disclosures as necessary.
