# Disclose to US users

!!! note
    **Important:** Verify that you have **Account Management** permission to complete the configuration for EU Consent and GDPR, US State regulations, and User Messaging Platform. See [Manage user access to your account](https://support.google.com/admob/answer/2784628) for details.

To help you comply with [U.S. states privacy laws](https://support.google.com/admob/answer/9561022), the Google Mobile Ads SDK lets you use Google [restricted data processing (RDP)](https://business.safety.google/rdp/) parameter to indicate whether to enable RDP. Google also supports the [Global Privacy Platform (GPP)](https://iabtechlab.com/standards/global-privacy-platform-gpp/) for applicable US states.

When the Google Mobile Ads SDK uses either signal, the SDK restricts certain unique identifiers and other data processed in the provision of services to you.

You must decide how restricted data processing can support your compliance plans and when to enable it. Determine whether to use the RDP parameter directly or signal consent and privacy choices with the GPP Specification.

This guide helps you enable RDP globally via local storage or on a per-ad request basis, and use the GPP signal.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/privacy/us-states)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/privacy/us-states)

## Prerequisites

- Complete the [Get started guide](../user_messaging_tools/get_started.md).
- Create a [U.S. state regulations message](https://support.google.com/admob/answer/13467025).

## Tag for under age of consent

To indicate whether a user is under the age of consent, set `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA). When you set TFUA to `true`, the UMP SDK doesn't request consent from the user. If your app has a mixed audience, set this parameter for child users to ensure consent is not requested.

!!! warning "Important"
    The UMP SDK does not forward the TFUA tag set on consent requests to the Mobile Ads SDK. You must explicitly set `tag_for_under_age_of_consent` on ad requests. If you don't set `tag_for_under_age_of_consent` on ad requests, the UMP SDK does not collect any information that allows Google to determine whether or not users under the age of consent use your app.

    For more information, see [Tag an ad request for users under the age of consent](../../advanced_topics/targeting.md).

The following example sets TFUA to `true` on a UMP consent request:

=== "GDScript"

    ```gdscript
    var params := ConsentRequestParameters.new()
    params.tag_for_under_age_of_consent = true

    UserMessagingPlatform.consent_information.update(params, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Core;

    var parameters = new ConsentRequestParameters
    {
        // Indicate the user is under age of consent.
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## Enable the RDP signal

Google supports two ways to enable Restricted Data Processing (RDP). Both are valid and supported by the Google Mobile Ads SDK:

### Globally in local storage (Recommended)

In the official Android and iOS SDKs, Google recommends writing the `gad_rdp` key directly to local storage (`SharedPreferences` on Android, `UserDefaults` on iOS). The Google Mobile Ads SDK reads this key automatically during ad loading and applies RDP to all ad requests across the app:

=== "GDScript"

    ```gdscript
    if OS.get_name() == "Android":
        ApplicationPreferences.set_int("gad_rdp", 1)
    elif OS.get_name() == "iOS":
        ApplicationPreferences.set_bool("gad_rdp", true)
    ```

=== "C#"

    ```csharp
    if (OperatingSystem.IsAndroid())
    {
        ApplicationPreferences.SetInt("gad_rdp", 1);
    }
    else if (OperatingSystem.IsIOS())
    {
        ApplicationPreferences.SetBool("gad_rdp", true);
    }
    ```

### Per-ad request

You can also enable the RDP signal on a per-ad request basis by inserting the key `rdp` with a value of `1` (or `"1"` in C#) into the `extras` dictionary of an [`AdRequest`](../../reference/classes/AdRequest.md):

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["rdp"] = 1
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("rdp", "1");
    ```

!!! note
    **Tip:** You can use network tracing or a proxy tool such as [Charles](https://www.charlesproxy.com/) to capture your app's HTTPS traffic and inspect the ad requests for a **&rdp=** parameter.

## Use the IAB GPP Signal

If you collect consent decisions with a consent management platform (CMP) or your own custom messaging, the Google Mobile Ads SDK respects GPP signals written to local storage. The User Messaging Platform (UMP) SDK supports writing the GPP signal. To gather US state consent, configure a **U.S. state regulations** message in your AdMob account under **Privacy & messaging**. For UMP setup, see [Set up UMP SDK](../user_messaging_tools/get_started.md).

### Read consent choices

The UMP SDK writes GPP data to local storage following the [IAB GPP specification](https://iabtechlab.com/standards/global-privacy-platform-gpp/). Note that the UMP SDK only populates these two keys for handling US state regulations:

- `IABGPP_HDR_GppString`: The GPP string containing encoded user consent and opt-out preferences.
- `IABGPP_GppSID`: The section IDs included in the GPP string (for example, `7` for US National).

You can read the consent choices from local storage using [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md):

=== "GDScript"

    ```gdscript
    var gpp_string := ApplicationPreferences.get_string("IABGPP_HDR_GppString")
    var gpp_sid := ApplicationPreferences.get_string("IABGPP_GppSID")
    ```

=== "C#"

    ```csharp
    var gppString = ApplicationPreferences.GetString("IABGPP_HDR_GppString");
    var gppSid = ApplicationPreferences.GetString("IABGPP_GppSID");
    ```

## Test your US states regulations messaging

To test your U.S. states regulations message flow using the UMP SDK on a test device, force the debug geography on [`ConsentDebugSettings`](../../reference/classes/ConsentDebugSettings.md):

- **Simulate a regulated U.S. state:** Set `debug_geography` to `DebugGeography.Values.REGULATED_US_STATE` (or `DebugGeography.RegulatedUsState` in C#).
- **Suppress U.S. states regulations messages:** Set `debug_geography` to `DebugGeography.Values.OTHER` (or `DebugGeography.Other` in C#).

=== "GDScript"

    ```gdscript
    var request := ConsentRequestParameters.new()
    var debug_settings := ConsentDebugSettings.new()
    debug_settings.debug_geography = DebugGeography.Values.REGULATED_US_STATE
    debug_settings.test_device_hashed_ids.append("TEST-DEVICE-HASHED-ID")
    request.consent_debug_settings = debug_settings

    UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;

    var request = new ConsentRequestParameters();
    var debugSettings = new ConsentDebugSettings();
    debugSettings.DebugGeography = DebugGeography.RegulatedUsState;
    debugSettings.TestDeviceHashedIds.Add("TEST-DEVICE-HASHED-ID");
    request.ConsentDebugSettings = debugSettings;

    UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdated);
    ```

## Mediation

If you use [mediation](../../mediate/get_started.md), navigate to **Privacy & messaging** > **US states regulations** in the AdMob UI to manage ad partners for U.S. states. Consult each ad network partner's documentation to determine the options they offer for U.S. state regulations compliance.