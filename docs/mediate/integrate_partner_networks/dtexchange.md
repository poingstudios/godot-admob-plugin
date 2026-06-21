# Integrate DT Exchange with Mediation

This guide explains how to utilize the Google Mobile Ads SDK to load and present ads from DT Exchange (formerly Fyber) through [mediation](../get_started.md). It provides instructions on integrating DT Exchange into the mediation configuration of a Godot app and integrating the DT Exchange SDK and adapter.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/mediation/dt-exchange)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/mediation/dt-exchange)

## Supported integrations and ad formats

The AdMob mediation adapter for DT Exchange has the following capabilities:

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

## Step 1: Set up DT Exchange
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_1_set_up_dt_exchange) or [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_1_set_up_dt_exchange), as it will be the same for both.

## Step 2: Configure mediation settings for your AdMob ad unit
We recommend following the tutorial for [Android](https://developers.google.com/admob/android/mediation/dt-exchange#step_2) or [iOS](https://developers.google.com/admob/ios/mediation/dt-exchange#step_2), as it will be the same for both.

## Step 3: Import the DT Exchange SDK plugin

=== "Android"
    1. Download the plugin for [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extract the `.zip` file. Inside, you will find a `dtexchange` folder.
    3. Copy the contents of the `dtexchange` folder and paste them into the Android plugin folder at `res://addons/admob/android/bin/`.

=== "iOS"
    The DT Exchange adapter is **already included** in the standard iOS plugin download. If you followed the [iOS Installation guide](../../index.md#download-install), you should already have the necessary files (`poing-godot-admob-dtexchange.gdip` and related frameworks) in your `res://ios/plugins/` directory.

## Step 4: Enable the plugin

=== "Android"
    Make sure to enable **Dtexchange** in **Project Settings** (under `Admob > Android > Mediation > Dtexchange`).

=== "iOS"
    Make sure to check both `Ad Mob` and `Ad Mob Dt Exchange` under the Plugins list in your **iOS Export Presets** (as well as entering your AdMob App ID in the Plists config).

## Step 5: Optional steps (Regulatory Settings)

### GDPR Consent
DT Exchange allows passing GDPR consent choices to their SDK via either a boolean consent flag or an IAB consent string.

To pass boolean GDPR consent, use the following code:

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent(true)
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsent(true);
    ```

To pass the GDPR IAB consent string, use the following code:

=== "GDScript"

    ```gdscript
    DTExchange.set_gdpr_consent_string("your_iab_consent_string")
    ```

=== "C#"

    ```csharp
    DTExchange.SetGDPRConsentString("your_iab_consent_string");
    ```

### CCPA (US Privacy String)
To comply with CCPA, you can set the IAB US Privacy string. The following sample code shows how to pass this information to the DT Exchange SDK:

=== "GDScript"

    ```gdscript
    DTExchange.set_ccpa_string("1---")
    ```

=== "C#"

    ```csharp
    DTExchange.SetCCPAString("1---");
    ```
