# API Reference

This page lists the classes, enums, and callbacks provided by the Godot AdMob Plugin.

## Classes

| Class | Description |
| :--- | :--- |
| [MobileAds](classes/MobileAds.md) | Global configurations and SDK initialization entry point. |
| [RequestConfiguration](classes/RequestConfiguration.md) | Configuration settings applied globally to all ad requests. |
| [AdRequest](classes/AdRequest.md) | Request parameters used to load ads. |
| [AdSize](classes/AdSize.md) | Width and height definitions for Banner ads. |
| [AdView](classes/AdView.md) | A Godot node that loads and displays banner ads. |
| [AppOpenAd](classes/AppOpenAd.md) | Full-screen ad format shown when users open the app. |
| [AppOpenAdLoader](classes/AppOpenAdLoader.md) | Loader class responsible for fetching App Open Ads. |
| [InterstitialAd](classes/InterstitialAd.md) | Full-screen interstitial ad format. |
| [InterstitialAdLoader](classes/InterstitialAdLoader.md) | Loader class responsible for fetching Interstitial Ads. |
| [RewardedAd](classes/RewardedAd.md) | Full-screen rewarded ad format. |
| [RewardedAdLoader](classes/RewardedAdLoader.md) | Loader class responsible for fetching Rewarded Ads. |
| [RewardedInterstitialAd](classes/RewardedInterstitialAd.md) | Rewarded Interstitial ad format (semi-transparent overlay). |
| [RewardedInterstitialAdLoader](classes/RewardedInterstitialAdLoader.md) | Loader class responsible for fetching Rewarded Interstitial Ads. |
| [NativeOverlayAd](classes/NativeOverlayAd.md) | Native ad format overlaid on top of Godot scenes. |
| [ResponseInfo](classes/ResponseInfo.md) | Contains metadata and adapter response info for loaded ads. |
| [AdapterResponseInfo](classes/AdapterResponseInfo.md) | Metadata from a specific mediation network adapter. |
| [AdError](classes/AdError.md) | Information about errors occurring during ad display. |
| [LoadAdError](classes/LoadAdError.md) | Information about errors occurring during ad loading. |
| [AdValue](classes/AdValue.md) | Represents the monetary value of an ad impression. |
| [RewardedItem](classes/RewardedItem.md) | Represents a reward earned by the user (amount and type). |
| [InitializationStatus](classes/InitializationStatus.md) | Contains initialization status details for MobileAds. |
| [AdapterStatus](classes/AdapterStatus.md) | Represents initialization status for a single mediation adapter. |

## Enums

| Enum | Description |
| :--- | :--- |
| [AdPosition](enums.md#adposition) | Target alignment position on screen. |
| [AdChoicesPlacement](enums.md#adchoicesplacement) | Placement position for the AdChoices icon. |
| `NativeAdOptions` | Settings for rendering native ads. |
| [NativeMediaAspectRatio](enums.md#nativemediaaspectratio) | Media aspect ratio preference for native ads. |
| `NativeTemplateStyle` | Stylesheet configuration for native template overlay. |
| `NativeTemplateTextStyle` | Font and color configuration for text elements. |
| `NativeTemplateFontStyle` | Typographical font weights. |
| `AdVideoOptions` | Media control options for video ads. |
| `ServerSideVerificationOptions` | Security configurations for server-side rewarded callbacks. |

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
