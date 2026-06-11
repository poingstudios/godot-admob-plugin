# Integrate IronSource with Mediation

This guide explains how to utilize the Google Mobile Ads SDK for loading and presenting ads from IronSource through [mediation](../get_started.md). It provides instructions on integrating IronSource into the mediation configuration of a Godot app and integrating the IronSource SDK and adapter into your Godot app.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/ironsource)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/ironsource)

## Supported integrations and ad formats

The AdMob mediation adapter for IronSource has the following capabilities:

| Integration |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formats               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial | ✅ [^1]    |
| Native                |            |

[^1]: This format is only supported in waterfall integration.

## Prerequisites
- Complete the [Get started guide](../../README.md)
- Complete the mediation [Get started guide](../get_started.md)

## Step 1: Set up IronSource
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/ironsource#step_1_set_up_ironsource) or [iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_1_set_up_ironsource), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/ironsource#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_2), as it will be the same for both.

## Step 3: Import the IronSource SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find an `ironsource` folder.
    3. Copy the contents of the `ironsource` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The IronSource adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../README.md#download-install), you should already have the necessary files (`poing-godot-admob-ironsource.gdip` and related frameworks) in your `res://ios/plugins/` directory.

4. When exporting, make sure to enable `Ad Mob` and `Ad Mob IronSource` under your export presets.

## Step 4: Optional steps (Regulatory Settings)

### EU consent and GDPR
Under the Google [EU User Consent Policy](https://www.google.com/about/company/consentstaging.html), you must make certain disclosures to users in the European Economic Area (EEA) and obtain their consent for the use of cookies or other local storage, and for the use of personal data.

To pass GDPR consent info to the IronSource SDK, use the following code:

=== "GDScript"

    ```gdscript
    IronSource.set_consent(true)
    ```

=== "C#"

    ```csharp
    IronSource.SetConsent(true);
    ```

### CCPA
To comply with the CCPA, you can set metadata settings. The following sample code shows how to pass this information to the IronSource SDK:

=== "GDScript"

    ```gdscript
    IronSource.set_metadata("do_not_sell", "false")
    ```

=== "C#"

    ```csharp
    IronSource.SetMetaData("do_not_sell", "false");
    ```

### User ID
To set the IronSource User ID for rewarded ad integrations, use the following code:

=== "GDScript"

    ```gdscript
    IronSource.set_user_id("unique_user_id_123")
    ```

=== "C#"

    ```csharp
    IronSource.SetUserId("unique_user_id_123");
    ```
