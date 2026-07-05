# API Reference

This page lists the classes, enums, and callbacks provided by the Godot AdMob Plugin.

## Classes

| Class | Description |
| :--- | :--- |
| [MobileAds](classes/MobileAds.md) | Global configurations and SDK initialization entry point. |
| [RequestConfiguration](classes/RequestConfiguration.md) | Configuration settings applied globally to all ad requests. |
| [AdRequest](classes/AdRequest.md) | Request parameters used to load ads. |
| [AdSize](classes/AdSize.md) | Width and height definitions for Banner ads. |
| [AdPosition](classes/AdPosition.md) | Screen alignment layout for banner and native overlay ads. |
| [AdView](classes/AdView.md) | A Godot node that loads and displays banner ads. |
| [AdVideoOptions](classes/AdVideoOptions.md) | Playback behavior for video elements inside native ads. |
| [AppOpenAd](classes/AppOpenAd.md) | Full-screen ad format shown when users open the app. |
| [AppOpenAdLoader](classes/AppOpenAdLoader.md) | Loader class responsible for fetching App Open Ads. |
| [InterstitialAd](classes/InterstitialAd.md) | Full-screen interstitial ad format. |
| [InterstitialAdLoader](classes/InterstitialAdLoader.md) | Loader class responsible for fetching Interstitial Ads. |
| [RewardedAd](classes/RewardedAd.md) | Full-screen rewarded ad format. |
| [RewardedAdLoader](classes/RewardedAdLoader.md) | Loader class responsible for fetching Rewarded Ads. |
| [RewardedInterstitialAd](classes/RewardedInterstitialAd.md) | Rewarded Interstitial ad format (semi-transparent overlay). |
| [RewardedInterstitialAdLoader](classes/RewardedInterstitialAdLoader.md) | Loader class responsible for fetching Rewarded Interstitial Ads. |
| [NativeOverlayAd](classes/NativeOverlayAd.md) | Native ad format overlaid on top of Godot scenes. |
| [NativeAdOptions](classes/NativeAdOptions.md) | Preferences for rendering native overlay ads. |
| [NativeTemplateStyle](classes/NativeTemplateStyle.md) | Visual styling template for native overlay ads. |
| [NativeTemplateTextStyle](classes/NativeTemplateTextStyle.md) | Font and color configuration for text elements. |
| [ResponseInfo](classes/ResponseInfo.md) | Contains metadata and adapter response info for loaded ads. |
| [AdapterResponseInfo](classes/AdapterResponseInfo.md) | Metadata from a specific mediation network adapter. |
| [AdError](classes/AdError.md) | Information about errors occurring during ad display. |
| [LoadAdError](classes/LoadAdError.md) | Information about errors occurring during ad loading. |
| [AdValue](classes/AdValue.md) | Represents the monetary value of an ad impression. |
| [RewardedItem](classes/RewardedItem.md) | Represents a reward earned by the user (amount and type). |
| [InitializationStatus](classes/InitializationStatus.md) | Contains initialization status details for MobileAds. |
| [AdapterStatus](classes/AdapterStatus.md) | Represents initialization status for a single mediation adapter. |
| [ServerSideVerificationOptions](classes/ServerSideVerificationOptions.md) | Security configurations for server-side rewarded callbacks. |

## Enums

| Enum | Description |
| :--- | :--- |
| [AdChoicesPlacement](enums.md#adchoicesplacement) | Corner placement for the AdChoices icon. |
| [NativeMediaAspectRatio](enums.md#nativemediaaspectratio) | Media aspect ratio preference for native ads. |
| [NativeTemplateFontStyle](enums.md#nativetemplatefontstyle) | Typographical font weights for native ad text fields. |
| [AdValue.PrecisionType](enums.md#advalueprecisiontype) | Precision level of the ad revenue value. |
| [AdapterStatus.InitializationState](enums.md#adapterstatusinitializationstate) | Indicates whether a mediation adapter is ready. |
| [RequestConfiguration.TagForChildDirectedTreatment](enums.md#requestconfigurationtagforchilddirectedtreatment) | Child-directed treatment for COPPA compliance. |
| [RequestConfiguration.TagForUnderAgeOfConsent](enums.md#requestconfigurationtagforunderageofconsent) | Under age of consent for GDPR compliance. |

## Interfaces / Callbacks

| Callback | Description |
| :--- | :--- |
| [OnInitializationCompleteListener](listeners/OnInitializationCompleteListener.md) | Callback triggered when the SDK initialization completes. |
| [AdListener](listeners/AdListener.md) | Receives banner and overlay events. |
| [FullScreenContentCallback](listeners/FullScreenContentCallback.md) | Receives presentation events for full-screen formats. |
| [OnUserEarnedRewardListener](listeners/OnUserEarnedRewardListener.md) | Receives event when user earns a reward. |
| [AppOpenAdLoadCallback](listeners/AppOpenAdLoadCallback.md) | Handles loading outcomes for App Open Ads. |
| [InterstitialAdLoadCallback](listeners/InterstitialAdLoadCallback.md) | Handles loading outcomes for Interstitial Ads. |
| [RewardedAdLoadCallback](listeners/RewardedAdLoadCallback.md) | Handles loading outcomes for Rewarded Ads. |
| [RewardedInterstitialAdLoadCallback](listeners/RewardedInterstitialAdLoadCallback.md) | Handles loading outcomes for Rewarded Interstitial Ads. |
| [AdInspectorClosedListener](listeners/AdInspectorClosedListener.md) | Triggers when the native Ad Inspector is closed. |
