# IDFA support

This guide outlines the steps required to support the IDFA message as part of the UMP SDK. It is intended to be paired with [Get started](get_started.md) which gives an overview of how to get your app running with the UMP SDK and the basics of setting up your message. The guidance below is specific to the IDFA message.

!!! note
    If you enable both GDPR and IDFA messages, refer to [Which message your users will see](https://support.google.com/admob/answer/10115027#which_message) for the possible outcomes

This document is based on:

- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/privacy/idfa)

## Prerequisites

- Complete the [Get started guide](get_started.md)
- Create an [IDFA message](https://support.google.com/admob/answer/10115331)

## Update Info.plist

If you plan to use the UMP SDK to handle Apple's App Tracking Transparency (ATT) requirements, make sure you've created, configured, and published your [IDFA explainer message](https://support.google.com/admob/answer/10115027) in the AdMob UI.


In order for the UMP SDK to display a custom alert message in the iOS system dialog, update your `Info.plist` to add the `NSUserTrackingUsageDescription` key with a custom message string describing your usage.

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

The usage description appears as part of the ATT dialog when you present the consent form:

![idfa-alert](https://developers.google.com/static/admob/ump/images/idfa-alert.png)

Then, link the `AppTrackingTransparency` framework:

![link-att-framework](https://developers.google.com/static/admob/ump/images/link-att-framework.png)

That’s it! Your app will now show an IDFA explainer message prior to the IDFA ATT dialog.

### Testing

While testing, remember that the IDFA ATT dialog only appears a single time since [`requestTrackingAuthorization`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/requesttrackingauthorization(completionhandler:)) is a one-time request. The UMP SDK only has a form available to load if the authorization status is [`ATTrackingManagerAuthorizationStatusNotDetermined`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/authorizationstatus/notdetermined?language=objc).

To make the alert appear a second time, you must uninstall and reinstall your app on your test device.