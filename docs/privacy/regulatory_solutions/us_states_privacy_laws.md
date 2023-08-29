# U.S. states privacy laws compliance
!!! note
    **Important**: Please verify you have **Account Management** permission to complete configuration for EU Consent and GDPR, CCPA, and User Messaging Platform. To learn more please see the following [new user roles](https://support.google.com/admob/answer/2784628) article.

To help publishers comply with [U.S. states privacy laws](https://support.google.com/admob/answer/9561022), the Google Mobile Ads SDK allows publishers to use two different parameters to indicate whether Google should enable [restricted data processing (RDP)](https://business.safety.google/rdp/). The SDK provides publishers with the ability to set RDP at an ad request level utilizing the following signals:

- Google's RDP
- [IAB-defined](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf) `IABUSPrivacy_String`

When either parameter is used, Google restricts how it uses certain unique identifiers and other data processed in the provision of services to publishers. As a result, Google will only show non-personalized ads. These parameters override the RDP settings in the UI.

Publishers should decide for themselves how restricted data processing can support their compliance plans and when it should be enabled. It is possible to use both optional parameters at the same time, although they have the same effect on Google's ad serving.

This guide is intended to help publishers understand the steps required to enable these options on a per-ad request basis.

## RDP signal

To notify Google that RDP should be enabled using Google's signal, insert the key rdp as an extra parameter with a value of `1`.

```gdscript
var ad_request := AdRequest.new()
ad_request.extras["rdp"] = 1
```

!!! note
    **Tip:** You can use network tracing or a proxy tool such as [Charles](https://www.charlesproxy.com/) to capture your app's HTTPS traffic and inspect the ad requests for a **&rdp=** parameter.

## IAB signal

To notify Google that RDP should be enabled using IAB's signal, insert the key `IABUSPrivacy_String` as an extra parameter. Make sure that the string value you use is compliant with the [IAB specification](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf).

```gdscript
var ad_request := AdRequest.new()
ad_request.extras["IABUSPrivacy_String"] = "IAB_STRING"
```

!!! note
    **Tip:** You can use network tracing or a proxy tool such as [Charles](https://www.charlesproxy.com/) to capture your app's HTTPS traffic and inspect the ad requests for a **&us_privacy=** parameter.

## Mediation

!!! note
    **Important:** Please verify you have the necessary account permissions to complete mediation configuration. These permissions include access to inventory management, app access, and privacy and messaging features. To learn more please see the following [new user roles](https://support.google.com/admob/answer/2784628) article.

If you use [mediation](../../mediate/get_started.md), follow the steps in [CPRA settings](https://support.google.com/admob/answer/10860309) to add your mediation partners to the CCPA ad partners list in the AdMob UI. Also, consult each ad network partner's documentation to determine what options they offer to help towards CCPA compliance.