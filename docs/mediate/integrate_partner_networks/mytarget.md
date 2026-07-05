# Integrate myTarget with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from myTarget through [mediation](../get_started.md). It provides instructions on integrating myTarget into the mediation configuration of a Godot app and integrating the myTarget SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/mytarget)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/mytarget)

## Supported integrations and ad formats

The AdMob mediation adapter for myTarget has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Native                |            |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up myTarget
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/mytarget#step_1_set_up_mytarget) or [iOS](https://developers.google.com/admob/ios/mediation/mytarget#step_1_set_up_mytarget), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/mytarget#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/mytarget#step_2), as it will be the same for both.

## Step 3: Import the myTarget SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `mytarget` folder.
    3. Copy the contents of the `mytarget` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The myTarget adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-mytarget.gdip`) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **myTarget** in **Project Settings** (under `Admob > Android > Mediation > MyTarget`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob MyTarget` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Add required code
No additional code configuration is required for this partner integration.
