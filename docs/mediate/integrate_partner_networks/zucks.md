# Integrate Zucks with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from Zucks through [mediation](../get_started.md). It provides instructions on integrating Zucks into the mediation configuration of a Godot app and integrating the Zucks SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/zucks)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/zucks)

## Supported integrations and ad formats

The AdMob mediation adapter for Zucks has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     |   |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              |            |
| Rewarded Interstitial |            |
| Native                |            |

## Prerequisites
- Complete the [Get started guide](../../index.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up Zucks
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/zucks#step_1_set_up_zucks) or [iOS](https://developers.google.com/admob/ios/mediation/zucks#step_1_set_up_zucks), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/zucks#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/zucks#step_2), as it will be the same for both.

## Step 3: Import the Zucks SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `zucks` folder.
    3. Copy the contents of the `zucks` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    As Zucks is integrated via Custom Events on iOS, developers must manually add the Zucks SDK and AdMob adapter framework files to their Xcode project after export.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Zucks** in **Project Settings** (under `Admob > Android > Mediation > Zucks`).

=== "iOS"
    For iOS, there is no plugin checkbox in the Godot Export window. You just need to check the main `Ad Mob` plugin, export your project, and then manually link the Zucks frameworks in Xcode.

## Step 5: Optional steps (Regulatory Settings)
Zucks does not require any additional custom code configuration for GDPR or CCPA settings via the Google Mobile Ads adapter API. Consent and privacy settings are managed through standard AdMob dashboard configuration or platform-level options.
