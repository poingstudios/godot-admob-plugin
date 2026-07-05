# Ad serving modes

Under Google's [EU User Consent Policy](https://www.google.com/about/company/user-consent-policy.html), you must make certain disclosures to your users in the European Economic Area (EEA) and the UK, and obtain their consent for the use of cookies or other local storage where legally required, and for the collection, sharing, and use of personal data for ads personalization. This policy reflects the requirements of the EU ePrivacy Directive and the General Data Protection Regulation (GDPR). To comply with this policy, publishers are required to adopt a [Google-certified consent management platform](https://support.google.com/admob/answer/13554116) (CMP) that has integrated with the [TCF framework](https://iabeurope.eu/transparency-consent-framework/) such as the [User Messaging Platform SDK](../user_messaging_tools/get_started.md). Once adopted, the CMP presents consent choices, known as purposes, in your mobile app.

This document is based on:

- [Google Mobile Ads SDK Android - Ad serving modes](https://developers.google.com/admob/android/privacy/ad-serving-modes)
- [Google Mobile Ads SDK iOS - Ad serving modes](https://developers.google.com/admob/ios/privacy/ad-serving-modes)

The exact UI for the consent choices is kept up-to-date by Google, but here's an earlier version for reference:

![Consent choices sample image](https://developers.google.com/static/admob/images/privacy/consent-form-purposes.png)

!!! note
    **Important:** In addition to collecting purposes consent, you also need to collect vendor consent. Both purposes consent and vendor consent are required for any vendor, such as Google, to serve appropriate ads.

The different types of ads that can be served are:

- [Personalized ads](#personalized-ads)
- [Non-personalized ads](#non-personalized-ads)
- [Limited ads](#limited-ads)

## Personalized ads

[Personalized ads](https://support.google.com/admob/answer/7676680) are ads that make inferences about a user's interests based on the sites they visit or the apps they use. Google considers ads to be personalized when they are based on previously collected or historical data to determine or influence ad selection.

Google will serve personalized ads when all of the following criteria are met. For more information, read [requirements for personalized ads](https://support.google.com/admob/answer/9760862#consent-policies).

**Legend:** ✅ Consent &nbsp;&nbsp;&nbsp;&nbsp; ✔ Legitimate interest

| Purpose | User consent choice |
| --- | --- |
| Purpose 1 | ✅ |
| Purpose 2 | ✔ or ✅ |
| Purpose 3 | ✅ |
| Purpose 4 | ✅ |
| Purpose 7 | ✔ or ✅ |
| Purpose 9 | ✔ or ✅ |
| Purpose 10 | ✔ or ✅ |

## Non-personalized ads

[Non-personalized ads](https://support.google.com/admob/answer/7676680) are not based on a user's past behavior. Although non-personalized ads don't use cookies or mobile ad identifiers for ad targeting, these ads do still use cookies or mobile ad identifiers for frequency capping and aggregated ad reporting.

Google will serve non-personalized ads when all of the following criteria are met. For more information, see [Requirements for non-personalized ads](https://support.google.com/admob/answer/9760862#consent-policies).

**Legend:** ✅ Consent &nbsp;&nbsp;&nbsp;&nbsp; ✔ Legitimate interest &nbsp;&nbsp;&nbsp;&nbsp; 🚫 No consent

| Purpose | User consent choice |
| --- | --- |
| Purpose 1 | ✅ |
| Purpose 2 | ✔ or ✅ |
| Purpose 7 | ✔ or ✅ |
| Purpose 9 | ✔ or ✅ |
| Purpose 10 | ✔ or ✅ |

## Limited ads

[Limited ads (LTD)](https://support.google.com/admob/answer/10105530) disable all personalization and features that require using a local identifier.

Google serves limited ads when all of the following criteria are met. For more information, read [Launched: Limited ads 2.0](https://support.google.com/admob/answer/10105530#limited-ads-update).

- Special Purposes: 1, 2
- Legitimate Interest: 7 (optional only)
