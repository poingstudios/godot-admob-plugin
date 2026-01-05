# Integrate Liftoff Monetize (Vungle) with Mediation
!!! info
    
    **Note**: Vungle is now Liftoff Monetize.

This guide explains how to utilize the Google Mobile Ads SDK for loading and presenting ads from Liftoff Monetize through [mediation](../get_started.md), with comprehensive coverage of both bidding and waterfall integrations. It provides instructions on integrating Liftoff Monetize into the mediation configuration of a Godot app and integrating the Vungle SDK and adapter into your Godot app.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/liftoff-monetize)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/liftoff-monetize)

## Supported integrations and ad formats

The AdMob mediation adapter for AdColony has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | [^1]       |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial | [^1], [^2] |

[^1]: Not supported in bidding (supported only for waterfall mediation).
[^2]: For access to this feature, contact your Liftoff Monetize account manager.

## Prerequisites
- Godot 4.2+
- Latest [Godot AdMob Plugin](https://github.com/poingstudios/godot-admob-plugin/releases/latest) 
- Android deploy:
    - Android API level 19 or higher
    - Latest [Godot AdMob Android Plugin](https://github.com/poingstudios/godot-admob-android/releases/latest)
- iOS deploy:
    - iOS deployment target of 11.0 or higher
    - Latest [Godot AdMob iOS Plugin](https://github.com/poingstudios/godot-admob-ios/releases/latest)
- Complete the [Get started guide](../../README.md)
- Complete the mediation [Get started guide](../get_started.md)


## Limitations

- Liftoff Monetize does not support loading multiple ads using the same Placement Reference ID.
    - The Vungle adapter gracefully fails the 2nd request if another request for that placement is loading or waiting to be shown.
- Liftoff Monetize only supports loading 1 banner ad at a time.
    - The Vungle adapter gracefully fails subsequent banner requests if a banner ad is already loaded.

## Step 1: Set up Liftoff Monetize
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize) or [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_2), as it will be the same for both.

## Step 3: Import the Vungle SDK plugin

1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) and/or [iOS](https://github.com/poingstudios/godot-admob-ios/releases/latest).
2. Extract the `.zip` file. Inside, you will find an `vungle` folder.
3. Copy the contents of the `vungle` folder and paste the copied contents into the Android and/or iOS plugin folder.

    === "Android"
        ![android-vungle](../../assets/android/vungle.png)

    === "iOS"
        ![ios-vungle](../../assets/ios/vungle.png)

4. When export make sure to mark `Ad Mob` and `Ad Mob vungle`

    === "Android"
        ![android-vungle-export](../../assets/android/vungle-export.png)

    === "iOS"
        ![ios-vungle-export](../../assets/ios/vungle-export.png)

## Step 4: Additional code required

Liftoff Monetize necessitates a list of all placements that will be employed in your Godot app to be conveyed to their SDK. You can furnish this list of placements to the adapter using the `VungleInterstitialMediationExtras` and `VungleRewardedVideoMediationExtras` classes. The subsequent code examples illustrate how to employ these classes.

=== "Interstitial"

    ```gdscript
    var vungle_mediation_extras := VungleInterstitialMediationExtras.new()

    if OS.get_name() == "iOS":
        vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
    elif OS.get_name() == "Android":
        vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]

    var ad_request := AdRequest.new()
    ad_request.mediation_extras.append(vungle_mediation_extras)
    ```
=== "Rewarded"

    ```gdscript
	var vungle_mediation_extras := VungleRewardedMediationExtras.new()
	
	if OS.get_name() == "iOS":
		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
	elif OS.get_name() == "Android":
		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
	
	var ad_request := AdRequest.new()
	ad_request.mediation_extras.append(vungle_mediation_extras)
    ```

---

=== "Android"
    No additional code is required for Liftoff Monetize integration.

=== "iOS"
    **SKAdNetwork integration**

    Follow [Liftoff Monetize's documentation](https://support.vungle.com/hc/en-us/articles/360002925791-Integrate-Vungle-SDK-for-iOS#h_01EM0AZYJ84W7CWZHW4KRHQHXF) to add the SKAdNetwork identifiers to your project's `Info.plist` file.

## Step 5: Test your implementation
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_5_test_your_implementation) or [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_5_test_your_implementation), as it will be the same for both.

## Optional steps

!!! info
    
    **Important**: Please verify you have **Account Management** permission to complete configuration for EU Consent and GDPR, CCPA, and User Messaging Platform. To learn more please see the following [new user roles](https://support.google.com/admob/answer/2784628) article.


### EU consent and GDPR
Under the Google [EU User Consent Policy](https://www.google.com/about/company/consentstaging.html), it's mandatory to provide certain disclosures and obtain consents from users within the European Economic Area (EEA) regarding the utilization of device identifiers and personal data. This policy aligns with the EU ePrivacy Directive and the General Data Protection Regulation (GDPR). When seeking consent, you must explicitly identify each ad network within your mediation chain that may collect, receive, or utilize personal data. Additionally, you should furnish information about how each network intends to use this data. Importantly, Google currently cannot automatically transmit the user's consent choice to these networks.

The following sample code shows how to pass this consent information to the Vungle SDK. If you choose to call this method, it is recommended that you do so prior to requesting ads through the Google Mobile Ads SDK.

```gdscript
Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "1.0.0")
```

See [GDPR recommended implementation instructions](https://support.vungle.com/hc/en-us/articles/360047780372#gdpr-recommended-implementation-instructions-0-1) for more details and the values that can be provided in the method.

#### Add Liftoff to GDPR ad partners list
Follow the steps in [GDPR settings](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) to add Liftoff to the GDPR ad partners list in the AdMob UI.

### CCPA
The [California Consumer Privacy Act (CCPA)](https://support.google.com/admob/answer/9561022) mandates that California state residents have the right to opt out of the "sale" of their "personal information," as defined by the law. This opt-out option should be prominently displayed through a "Do Not Sell My Personal Information" link on the homepage of the party engaging in the sale.

The [CCPA preparation](../../privacy/regulatory_solutions/us_states_privacy_laws.md) guide offers a feature to enable [restricted data processing](https://privacy.google.com/businesses/rdp/) for Google ad serving. However, Google cannot apply this setting to every ad network within your mediation chain. Therefore, it is essential to identify each ad network in your mediation chain that might be involved in the sale of personal information and follow the specific guidance provided by each of those networks to ensure CCPA compliance.

The following sample code shows how to pass this consent information to the Vungle SDK. If you choose to call this method, it is recommended that you do so prior to requesting ads through the Google Mobile Ads SDK.

```gdscript
Vungle.update_ccpa_status(Vungle.Consent.OPTED_IN)
```

#### Add Liftoff to CCPA ad partners list
Follow the steps in [CCPA settings](https://support.google.com/admob/answer/10860309) to add Liftoff to the CCPA ad partners list in the AdMob UI.

### Network-specific parameters
The Vungle adapter for Godot supports an additional request parameter that can be conveyed to the adapter using either the `VungleRewardedMediationExtras` or `VungleInterstitialMediationExtras` class, depending on the ad format you are implementing. These classes include the following properties:

- `sound_enabled`: Determines whether sound should be enabled when playing video ads.

- `user_id`: A string representing the Incentivized User ID for Godot's Liftoff Monetize integration.

- `all_placements`: An array comprising all Placement IDs within the app (this is not required for apps employing Vungle SDK 6.2.0 or higher).

For iOS, you can simply use the `VungleAdNetworkExtras` class.

Here's a code example of how to create an ad request that sets these parameters:

=== "Interstitial"

    ```gdscript
	var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
	
	if OS.get_name() == "iOS":
		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
		vungle_mediation_extras.sound_enabled = true
		vungle_mediation_extras.user_id = "ios_user_id"
	elif OS.get_name() == "Android":
		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
		vungle_mediation_extras.sound_enabled = true
		vungle_mediation_extras.user_id = "android_user_id"
	
	var ad_request := AdRequest.new()
	ad_request.mediation_extras.append(vungle_mediation_extras)
    ```
=== "Rewarded"

    ```gdscript
    var vungle_mediation_extras := VungleRewardedMediationExtras.new()

    if OS.get_name() == "iOS":
        vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
        vungle_mediation_extras.sound_enabled = true
        vungle_mediation_extras.user_id = "ios_user_id"
    elif OS.get_name() == "Android":
        vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
        vungle_mediation_extras.sound_enabled = true
        vungle_mediation_extras.user_id = "android_user_id"

    var ad_request := AdRequest.new()
    ad_request.mediation_extras.append(vungle_mediation_extras)
    ```


## Error codes
If the adapter fails to receive an ad from Audience Network, publishers can check the underlying error from the ad response using `ResponseInfo` under the following classes:

=== "Android"
    | Format       | Class name                                     |
    |--------------|------------------------------------------------|
    | Banner       | com.vungle.mediation.VungleInterstitialAdapter |
    | Interstitial | com.vungle.mediation.VungleInterstitialAdapter |
    | Rewarded     | com.vungle.mediation.VungleAdapter             |

=== "iOS"
    | Format       | Class name                          |
    |--------------|-------------------------------------|
    | Banner       | GADMAdapterVungleInterstitial       |
    | Interstitial | GADMAdapterVungleInterstitial       |
    | Rewarded     | GADMAdapterVungleRewardBasedVideoAd |

Here are the codes and accompanying messages thrown by the Liftoff Monetize adapter when an ad fails to load:

=== "Android"
    | Error code | Domain                          | Reason                                                                                                         |
    |------------|---------------------------------|----------------------------------------------------------------------------------------------------------------|
    | 0-100      | com.vungle.warren               | Vungle SDK returned an error. See [document](https://support.vungle.com/hc/en-us/articles/360047780372-Advanced-Settings#exception-codes-for-debugging-0-9) for more details. |
    | 101        | com.google.ads.mediation.vungle | Invalid server parameters (e.g. app ID or placement ID).                                                       |
    | 102        | com.google.ads.mediation.vungle | The requested banner size does not map to a valid Liftoff Monetize ad size.                                    |
    | 103        | com.google.ads.mediation.vungle | Liftoff Monetize requires an Activity context to request ads.                                                  |
    | 104        | com.google.ads.mediation.vungle | The Vungle SDK cannot load multiple ads for the same placement ID.                                             |
    | 105        | com.google.ads.mediation.vungle | The Vungle SDK failed to initialize.                                                                           |
    | 106        | com.google.ads.mediation.vungle | Vungle SDK returned a successful load callback, but Banners.getBanner() or Vungle.getNativeAd() returned null. |
    | 107        | com.google.ads.mediation.vungle | Vungle SDK is not ready to play the ad.                                                                        |

=== "iOS"
    | Error code | Domain                      | Reason                                                                                                                |
    |------------|-----------------------------|-----------------------------------------------------------------------------------------------------------------------|
    | 1-100      | Sent by Vungle SDK          | Vungle SDK returned an error. See [code](https://github.com/Vungle/iOS-SDK/blob/6.12.0/VungleSDK.xcframework/ios-arm64_armv7/VungleSDK.framework/Headers/VungleSDK.h) for more details. |
    | 101        | com.google.mediation.vungle | Liftoff Monetize server parameters configured in the AdMob UI are missing/invalid.                                    |
    | 102        | com.google.mediation.vungle | An ad is already loaded for this network configuration. Vungle SDK cannot load a second ad for the same placement ID. |
    | 103        | com.google.mediation.vungle | The requested ad size does not match a Liftoff Monetize supported banner size.                                        |
    | 104        | com.google.mediation.vungle | Vungle SDK could not render the banner ad.                                                                            |
    | 105        | com.google.mediation.vungle | Vungle SDK only supports loading 1 banner ad at a time, regardless of placement ID.                                   |
    | 106        | com.google.mediation.vungle | Vungle SDK sent a callback saying the ad is not playable.                                                             |