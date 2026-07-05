# Integrate LINE Ads Network with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from LINE Ads Network (FiveAd) through [mediation](../get_started.md). It provides instructions on integrating LINE Ads Network into the mediation configuration of a Godot app and integrating the LINE Ads Network SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/line)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/line)

## Supported integrations and ad formats

The AdMob mediation adapter for LINE Ads Network has the following capabilities:

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

## Step 1: Set up LINE Ads Network
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/line#step_1_set_up_line_ads_network) or [iOS](https://developers.google.com/admob/ios/mediation/line#step_1_set_up_line_ads_network), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/line#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/line#step_2), as it will be the same for both.

## Step 3: Import the LINE Ads Network SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `line` folder.
    3. Copy the contents of the `line` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The LINE Ads Network adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-line.gdip`) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Line** in **Project Settings** (under `Admob > Android > Mediation > Line`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob Line` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).
