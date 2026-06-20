# Integrate maio with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from maio through [mediation](../get_started.md). It provides instructions on integrating maio into the mediation configuration of a Godot app and integrating the maio SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/maio)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/maio)

## Supported integrations and ad formats

The AdMob mediation adapter for maio has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     |   |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                |            |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial |            |
| Native                |            |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up maio
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/maio#step_1_set_up_maio) or [iOS](https://developers.google.com/admob/ios/mediation/maio#step_1_set_up_maio), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/maio#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/maio#step_2), as it will be the same for both.

## Step 3: Import the maio SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `maio` folder.
    3. Copy the contents of the `maio` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The maio adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-maio.gdip`) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Maio** in **Project Settings** (under `Admob > Android > Mediation > Maio`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob Maio` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Add required code
No additional code configuration is required for this partner integration.
