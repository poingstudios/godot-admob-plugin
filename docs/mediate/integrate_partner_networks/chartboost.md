# Integrate Chartboost with Mediation

This guide explains how to utilize the Google Mobile Ads SDK for loading and presenting ads from Chartboost through [mediation](../get_started.md). It provides instructions on integrating Chartboost into the mediation configuration of a Godot app and integrating the Chartboost SDK and adapter into your Godot app.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/chartboost)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/chartboost)

## Supported integrations and ad formats

The AdMob mediation adapter for Chartboost has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial |            |
| Native                |            |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up Chartboost
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/chartboost#step_1_set_up_chartboost) or [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_1_set_up_chartboost), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/chartboost#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_2), as it will be the same for both.

## Step 3: Import the Chartboost SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `chartboost` folder.
    3. Copy the contents of the `chartboost` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The Chartboost adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-chartboost.gdip` and related frameworks) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Chartboost** in **Project Settings** (under `Admob > Android > Mediation > Chartboost`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob Chartboost` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Optional steps (Regulatory Settings)

### EU consent and GDPR
Under the Google [EU User Consent Policy](https://www.google.com/about/company/consentstaging.html), you must make certain disclosures to users in the European Economic Area (EEA) and obtain their consent for the use of cookies or other local storage, and for the use of personal data.

To pass GDPR consent info to the Chartboost SDK, use the following code:

=== "GDScript"

    ```gdscript
    Chartboost.set_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetConsent(true);
    ```

### CCPA
To comply with the CCPA, you can set "do not sell" settings. The following sample code shows how to pass this information to the Chartboost SDK:

=== "GDScript"

    ```gdscript
    Chartboost.set_ccpa_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetCCPAConsent(true);
    ```
