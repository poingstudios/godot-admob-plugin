# Integrate i-mobile with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from i-mobile through [mediation](../get_started.md). It provides instructions on integrating i-mobile into the mediation configuration of a Godot app and integrating the i-mobile SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/imobile)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/imobile)

## Supported integrations and ad formats

The AdMob mediation adapter for i-mobile has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     |   |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              |             |
| Rewarded Interstitial |            |
| Native                |            |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up i-mobile
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/imobile#step_1_set_up_i-mobile) or [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_1_set_up_i-mobile), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/imobile#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_2), as it will be the same for both.

## Step 3: Import the i-mobile SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find an `imobile` folder.
    3. Copy the contents of the `imobile` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The i-mobile adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-imobile.gdip` and related frameworks) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Imobile** in **Project Settings** (under `Admob > Android > Mediation > Imobile`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob iMobile` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Optional steps (Regulatory Settings)
i-mobile does not require any additional custom code configuration for GDPR or CCPA settings via the Google Mobile Ads adapter API. Consent and privacy settings are managed through standard AdMob dashboard configuration or platform-level options.
