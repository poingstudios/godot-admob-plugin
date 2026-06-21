# Integrate Pangle with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from Pangle through [mediation](../get_started.md). It provides instructions on integrating Pangle into the mediation configuration of a Godot app and integrating the Pangle SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/pangle)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/pangle)

## Supported integrations and ad formats

The AdMob mediation adapter for Pangle has the following capabilities:

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

## Step 1: Set up Pangle
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/pangle#step_1_set_up_pangle) or [iOS](https://developers.google.com/admob/ios/mediation/pangle#step_1_set_up_pangle), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/pangle#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/pangle#step_2), as it will be the same for both.

## Step 3: Import the Pangle SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `pangle` folder.
    3. Copy the contents of the `pangle` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The Pangle adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-pangle.gdip`) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Pangle** in **Project Settings** (under `Admob > Android > Mediation > Pangle`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob Pangle` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Add required code
No additional code configuration is required for this partner integration.
