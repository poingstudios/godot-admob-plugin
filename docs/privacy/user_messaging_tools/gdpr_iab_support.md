# Disclose to EEA users

Under the Google [EU User Consent Policy](https://www.google.com/about/company/user-consent-policy/), you must make certain disclosures to your users in the European Economic Area (EEA), the United Kingdom (UK), and Switzerland, and obtain their consent to use cookies or other local storage, where legally required, and to use personal data (such as AdID) to serve ads. This policy reflects the requirements of the EU ePrivacy Directive and the General Data Protection Regulation (GDPR).

This guide outlines the steps required to support the GDPR IAB TCF v2 message as part of the UMP SDK. It is intended to be paired with [Get started](get_started.md) which gives an overview of how to get your app running with the UMP SDK and the basics of setting up your message. The following guidance is specific to the GDPR IAB TCF v2 message. For more information, see [How IAB requirements affect EU consent messages](https://support.google.com/admob/answer/10207733).

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/privacy/gdpr)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/privacy/gdpr)

## Prerequisites

- Complete the [Get started guide](get_started.md).
- Create a [European regulation message for apps](https://support.google.com/admob/answer/10113207).

## Consent revocation

GDPR requires [consent revocation](https://support.google.com/admob/answer/10113915) to allow users to withdraw their consent choices at any time. See [Privacy options](get_started.md) to implement a way for users to withdraw their consent choices.

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

## Set up consent in AdMob Mediation

To set up consent in AdMob Mediation, complete the steps in the following sections.

### Add ad partners to GDPR messages

Follow the steps in [Add ad partners to published GDPR messages](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) to add your mediation partners to the ad partners list. Failure to do so can lead to partners failing to serve ads on your app.

The following table lists the ad tech partner name for each ad source:

| Ad source | Ad tech partner name |
| --- | --- |
| AppLovin | AppLovin Corp. |
| BidMachine | BidMachine |
| BIGO Ads SDK | Empathy Technology Pte.Ltd. (BIGO Ads) |
| Chartboost | Chartboost |
| DT Exchange | DT Exchange (Fyber Monetization) |
| i-mobile | i-mobile |
| InMobi | InMobi |
| ironSource Ads | ironSource Mobile |
| Liftoff Monetize | Liftoff |
| LY Ads Network | LY Ads Network |
| maio | maio |
| Meta Audience Network | Meta |
| Mintegral | Mobvista/Mintegral |
| Moloco Ads SDK | Moloco Ads |
| myTarget | Mail.ru |
| Pangle | Pangle DSP |
| PubMatic OpenWrap SDK | PubMatic |
| Unity Ads | Unity Ads |
| Verve HyBid SDK | Verve Group |

### Forward consent to ad sources

The following table shows which ad sources support passing GDPR consent signals from consent management platforms that integrate with IAB's Transparency and Consent Framework (TCF) and [Google's Additional Consent specification](https://support.google.com/admob/answer/9681999) to the SDK of the ad sources:

| Ad source | Minimum supported version |
| --- | --- |
| AppLovin | 7.0.0 |
| BidMachine | 1.0.0 |
| BIGO Ads SDK | 1.0.0 |
| Chartboost | 4.14.0 |
| DT Exchange | 3.3.0 |
| i-mobile | N/A¹ |
| InMobi | 4.6.4 |
| ironSource Ads | 2.6.0 |
| Liftoff Monetize | 5.2.2 |
| LY Ads Network | N/A¹ |
| maio | N/A¹ |
| Meta Audience Network | N/A² |
| Mintegral | 2.2.3 |
| Moloco Ads SDK | 1.0.0 |
| myTarget | 3.40.0 |
| Pangle | 5.9.0 |
| PubMatic OpenWrap SDK | 1.0.0 |
| Unity Ads | 3.20.0 |

¹ *Ad source doesn't serve EEA traffic.*  
² *For details, reach out to your Meta partner manager.*

## How to read consent choices

After GDPR consent has been collected, you can read consent choices from local storage following the [TCF v2 spec](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details).

The `IABTCF_PurposeConsents` key indicates consent for each of the [TCF purposes](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/#Appendix_A_Purposes_Features_and_Special_Purposes_Definitions). You can read and write application preferences using [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md).

The following code snippet shows how to check consent for Purpose 1:

=== "GDScript"

    ```gdscript
    # Example value: "1111111111"
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents")

    # Purposes are zero-indexed. Index 0 contains information about Purpose 1.
    if not purpose_consents.is_empty():
        var purpose_one_string := purpose_consents[0]
        var has_consent_for_purpose_one := purpose_one_string == "1"
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;

    // Example value: "1111111111"
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents");

    // Purposes are zero-indexed. Index 0 contains information about Purpose 1.
    if (!string.IsNullOrEmpty(purposeConsents))
    {
        char purposeOneString = purposeConsents[0];
        bool hasConsentForPurposeOne = purposeOneString == '1';
    }
    ```

## Frequently asked questions

!!! note
    See [European regulations message FAQs](https://support.google.com/admob/answer/13554116) for additional frequently asked questions.

**What happens if I take no action to meet the Consent Management Platform Requirements for serving ads in the EEA, the UK, and Switzerland?**

Beginning January 16, 2024, if a partner doesn't adopt a [Google-certified CMP](https://support.google.com/admob/answer/13554116), only [Limited Ads](https://support.google.com/admob/answer/9882911) will be eligible to serve on EEA and UK traffic.

Enforcement began January 16, 2024 and ramped up across all EEA and UK traffic. Have a certified CMP in place to ensure your monetization is not impacted.

**How can I check if the user consented?**

Consent is not represented by a single bit, but rather a set of purposes and vendors as defined in the IAB TCF specification. See [Consent Policies: Personalized & Non-Personalized Ads](https://support.google.com/admanager/answer/9012903) for Google Ads personalization criteria.

Additionally, ad techs on Google's [Ad technology providers](https://support.google.com/admob/answer/9012903) (ATP) list that are not registered in the TCF vendor list use [Google's Additional Consent technical specification](https://support.google.com/admob/answer/9681999) for consent collection. Google publishes the list of ad technology providers not registered with the IAB and their IDs at [additional-consent-providers.csv](https://storage.googleapis.com/tcfac/additional-consent-providers.csv).

To debug an individual ad request, use the [Troubleshoot privacy settings](../../advanced_topics/ad_inspector/troubleshoot_privacy.md) feature in ad inspector to view the following privacy signals passed in the ad request as part of publisher integration with the IAB Europe TCF:

| Ad inspector label | Ad request query parameter | Meaning |
| --- | --- | --- |
| GDPR applies (`IABTCF_gdprApplies`) | `gdpr` | Whether GDPR applies for this ad request. |
| TC string (`IABTCF_TCString`) | `gdpr_consent` | The TC String. The IAB provides a web tool where you can manually decode the value. |
| AC string (`IABTCF_AddtlConsent`) | `addtl_consent` | The AC string from Google's Additional Consent technical specification. |

To read consent choices programmatically, see [How to read consent choices](#how-to-read-consent-choices) for more information.

**Do I need to use Google's UMP SDK to meet the CMP requirement?**

No, you can use any CMP from the [list of Google-certified CMPs](https://support.google.com/admob/answer/13554116) to serve ads.

**How can I show the consent form again using the UMP SDK even if the user has already consented?**

If a user has already made a consent decision, Google's consent management solution won't request to gather new consent until the TC string is expired or otherwise becomes invalid.

GDPR requires consent modification to allow users to withdraw their consent choices at any time. See [privacy options](get_started.md) to implement a way for users to withdraw their consent choices. To show a consent form again, call `UserMessagingPlatform.show_privacy_options_form()` (`UserMessagingPlatform.ShowPrivacyOptionsForm()`).

**I integrated a Google-certified CMP, but I'm not seeing any ad requests get made to mediation partners even from users who consented. Why is this happening?**

Under TCF, Google checks that ad technology providers and other programmatic demand sources don't violate Google policy and have at least one legal basis for processing data prior to including them in the mediation waterfall. Navigate to the [Set up consent in AdMob Mediation](#set-up-consent-in-admob-mediation) section for more information.

Some mediation partners in [Google's Ad Tech Providers (ATP) list](https://support.google.com/admob/answer/9012903) are not registered in the TCF vendor list. These partners instead use [Google's Additional Consent technical specification](https://support.google.com/admob/answer/9681999) for consent collection. When using a third-party CMP, you should do the following:

1. Confirm that the third-party CMP supports storing the ACString.
2. Include each mediation partner in the list of ad technology providers that the third-party CMP uses to gather consent.

**Can I change how my app functions if users don't consent? Is this allowed by policy?**

Publishers can read the IAB TCF string in their apps. See [How to read consent choices](#how-to-read-consent-choices) for information on reading consent choices programmatically. Publishers should review their obligations under relevant regulations with legal counsel.

**When I select Manage Options and consent to all purposes, I'm not seeing any ads? Why is this happening?**

In addition to collecting purposes consent you also need to collect vendor consent. Both purposes consent and vendor consent are required for any vendor, such as Google, to serve appropriate ads.

**What is the best practice for showing both the iOS ATT alert and GDPR consent to the same user?**

We recommend showing the GDPR consent message first and the iOS ATT alert second if the user consented to GDPR. This is already handled by the UMP SDK if you configure both messages in the AdMob UI. See [Which message your users will see](https://support.google.com/admob/answer/10115027) for more information.

If you are not showing the ATT alert using the UMP SDK, we recommend you [read consent choices once GDPR consent is collected](#how-to-read-consent-choices) to determine whether to show the iOS ATT alert.

**How do I implement the AC String version 2 for users who already consented to version 1?**

Check the `IABTCF_AddtlConsent` key in local storage per [Google's Additional Consent technical specification](https://support.google.com/admob/answer/9681999) to determine whether a user has consented to AC String version 2 and if you need to show the consent form again:

=== "GDScript"

    ```gdscript
    # Example value: "2~1.35.41.101~dv.9.21.81"
    var additional_consent := ApplicationPreferences.get_string("IABTCF_AddtlConsent")

    # Index 0 contains information about the specification version number.
    if not additional_consent.is_empty():
        var spec_ac_version := additional_consent[0]
        var is_ac_version_2 := spec_ac_version == "2"
    ```

=== "C#"

    ```csharp
    // Example value: "2~1.35.41.101~dv.9.21.81"
    string additionalConsent = ApplicationPreferences.GetString("IABTCF_AddtlConsent");

    // Index 0 contains information about the specification version number.
    if (!string.IsNullOrEmpty(additionalConsent))
    {
        char specACVersion = additionalConsent[0];
        bool isACVersion2 = specACVersion == '2';
    }
    ```
