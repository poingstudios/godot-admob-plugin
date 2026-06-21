# Integrate PubMatic OpenWrap with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from PubMatic through [mediation](../get_started.md). It provides instructions on integrating PubMatic into the mediation configuration of a Godot app and integrating the PubMatic SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/pubmatic)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/pubmatic)

## Supported integrations and ad formats

The AdMob mediation adapter for PubMatic has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial  | ✅          |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up PubMatic OpenWrap
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/pubmatic#step_1_set_up_pubmatic) or [iOS](https://developers.google.com/admob/ios/mediation/pubmatic#step_1_set_up_pubmatic), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/pubmatic#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/pubmatic#step_2), as it will be the same for both.

## Step 3: Import the PubMatic OpenWrap SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `pubmatic` folder.
    3. Copy the contents of the `pubmatic` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The PubMatic adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-pubmatic.gdip`) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **PubMatic** in **Project Settings** (under `Admob > Android > Mediation > Pubmatic`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob PubMatic` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Add required code
No additional code configuration is required for this partner integration.
