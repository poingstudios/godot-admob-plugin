# Integrate Unity Ads with Mediation

This guide explains how to utilize the Google Mobile Ads SDK for loading and presenting ads from Unity Ads through [mediation](../get_started.md). It provides instructions on integrating Unity Ads into the mediation configuration of a Godot app and integrating the Unity Ads SDK and adapter into your Godot app.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/unity)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/unity)

## Supported integrations and ad formats

The AdMob mediation adapter for Unity Ads has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial | ✅          |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up Unity Ads
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/unity#step_1_set_up_unity_ads) or [iOS](https://developers.google.com/admob/ios/mediation/unity#step_1_set_up_unity_ads), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/unity#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/unity#step_2), as it will be the same for both.

## Step 3: Import the Unity Ads SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `unity_ads` folder.
    3. Copy the contents of the `unity_ads` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The Unity Ads adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-unity_ads.gdip` and related frameworks) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Unity Ads** in **Project Settings** (under `Admob > Android > Mediation > Unity Ads`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob Unity Ads` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Additional settings

### EU User Consent Policy
To pass consent information to the Unity Ads SDK, use the following code:

=== "GDScript"

    ```gdscript
    UnityAds.set_consent(true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetConsent(true);
    ```

### Privacy Consent
To set privacy consent (e.g., for CCPA), use the following code:

=== "GDScript"

    ```gdscript
    UnityAds.set_privacy_consent("user_privacy_data", true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetPrivacyConsent("user_privacy_data", true);
    ```
