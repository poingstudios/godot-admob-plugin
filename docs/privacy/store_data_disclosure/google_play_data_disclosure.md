# Google Play data disclosure

In May 2021, Google Play [announced the new Data safety section](https://android-developers.googleblog.com/2021/05/new-safety-section-in-google-play-will.html), which is a developer-provided disclosure for an app's data collection, sharing, and security practices.

This page can help you complete the requirements for this data disclosure in regards to your usage of the Godot AdMob Plugin. On this page, you can find information on whether and how the Google Mobile Ads SDK handles end-user data, including any applicable settings or configurations you can control as the app developer.

!!! note
    **Important**: As the app developer, you are solely responsible for deciding how to respond to Google Play's Data safety section form regarding your app's data collection, sharing, and security practices.

This document is based on:

- [Google Mobile Ads SDK Android - Google Play Data Disclosure](https://developers.google.com/admob/android/privacy/play-data-disclosure)

## How to use the information on this page

This page lists the end-user data collected by the latest version of the Google Mobile Ads SDK. If you are using a prior version, consider updating to the latest version to ensure your app's disclosures are accurate.

To complete your data disclosure, you can use Android's [guide about data types](https://developer.android.com/guide/topics/data/collect-share) to help you determine which data types and purposes best describe the collected data. In your data disclosure, make sure to also account for how your specific app shares and uses the collected data.

## Data collected and shared automatically

The Google Mobile Ads SDK collects and shares the following data types *automatically* for advertising, analytics, and fraud prevention purposes.

| Data | By default, the Google Mobile Ads SDK... |
|------|-------------------------------------------|
| **IP address** | Collects device's IP address, which may be used to estimate the general location of a device. |
| **User product interactions** | Collects user product interactions and interaction information, including app launch, taps, and video views. |
| **Diagnostic information** | Collects information related to the performance of your app and the SDK, including app launch time, hang rate, and energy usage. |
| **Device and Account identifiers** | Collects [Android advertising (ad) ID](https://support.google.com/googleplay/android-developer/answer/6048248), [app set ID](https://developer.android.com/training/articles/app-set-id), and, if applicable, other identifiers related to signed-in accounts on the device. |

All of the user data collected by the Google Mobile Ads SDK is encrypted in transit using the Transport Layer Security (TLS) protocol.

## Data handling

Android ad ID collection is optional. The ad ID can be reset or deleted by users using ad ID controls in the Android settings menu. As the app developer, you can prevent the collection of ad IDs by [updating the app's manifest file](https://support.google.com/googleplay/android-developer/answer/6048248).

Certain other features in the Google Mobile Ads SDK, such as the [Limited Ads](https://support.google.com/admob/answer/10105530) feature, may also disable transmission of the ad ID and other data.

## Data collected and shared depending on your usage

If you are using any optional product features that involve additional data (such as advance reporting) or participating in any tests of new product features that involve additional data, be sure to check if those features or tests require additional data disclosures.

## Other helpful resources

- [Blog post](https://android-developers.googleblog.com/2021/10/launching-data-safety-in-play-console.html) announcing the Data safety form in Google Play Console.
- The Play Console's Data safety form is available on the [App content](https://play.google.com/console/developers/app/app-content/summary) page.
