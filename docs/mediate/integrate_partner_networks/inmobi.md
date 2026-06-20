# Integrate InMobi with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from InMobi through [mediation](../get_started.md). It provides instructions on integrating InMobi into the mediation configuration of a Godot app and integrating the InMobi SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/inmobi)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/inmobi)

## Supported integrations and ad formats

The AdMob mediation adapter for InMobi has the following capabilities:

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
| Native                | ✅          |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up InMobi
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/inmobi#step_1_set_up_inmobi) or [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_1_set_up_inmobi), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/inmobi#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_2), as it will be the same for both.

## Step 3: Import the InMobi SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find an `inmobi` folder.
    3. Copy the contents of the `inmobi` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The InMobi adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-inmobi.gdip` and related frameworks) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Inmobi** in **Project Settings** (under `Admob > Android > Mediation > Inmobi`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob InMobi` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Optional steps (Regulatory Settings)
InMobi does not require any additional custom code configuration for GDPR or CCPA settings via the Google Mobile Ads adapter API. Consent and privacy settings are managed automatically by using a Google-certified CMP (such as the UMP SDK) and adding InMobi as a custom ad partner in your AdMob/Ad Manager Dashboard settings.
