# GDPR IAB support

This guide outlines the steps required to support the GDPR IAB TCF v2 message as part of the UMP SDK. It is intended to be paired with [Get started](get_started.md) which gives an overview of how to get your app running with the UMP SDK and the basics of setting up your message. The guidance below is specific to the GDPR IAB TCF v2 message.

## Prerequisites

- Complete the [Get started guide](get_started.md)
- Create a [GDPR message for apps](https://support.google.com/admob/answer/10113207).

## Delay app measurement

By default, the Google Mobile Ads SDK initializes app measurement and begins sending user-level event data to Google immediately when the app starts. This initialization behavior ensures that you can enable AdMob user metrics without making additional code changes.

However, if your app requires user consent before these events can be sent, you can delay app measurement until you explicitly [initialize the Mobile Ads SDK](../../README.md) or load an ad.

=== "Android"
    To delay app measurement, add the following `<meta-data>` tag in your `res://android/build/AndroidManifest.xml`.
    ```xml
    <manifest>
        <application>
        <!-- Delay app measurement until MobileAds.initialize() is called. -->
        <meta-data
            android:name="com.google.android.gms.ads.DELAY_APP_MEASUREMENT_INIT"
            android:value="true"/>
        </application>
    </manifest>
    ```

=== "iOS"
    To delay app measurement, add the `GADDelayAppMeasurementInit` key with a boolean value of `YES` to your app's `Info.plist` of you exported Xcode project. You can make this change programmatically:

    ```xml
    <key>GADDelayAppMeasurementInit</key>
    <true/>
    ```

## Consent revocation

[Consent revocability](https://support.google.com/admob/answer/10113915) is a requirement of the Privacy & messaging user consent program. You must provide a link in your app's menu that allows users who want to revoke consent to do so, then present the consent message to those users again.

To accomplish this:

1. [Load a form](get_started.md#load-a-form-if-available) every time the user launches your app, so that the form is ready to display in case the user wishes to change their consent setting.
2. Present the form when the user selects the link in your app's menu.

```gdscript
var _consent_form : ConsentForm

func present_form() -> void:
	_consent_form.show(_on_consent_form_dismissed)
	
func _on_consent_form_dismissed(form_error : FormError):
	# Handle dismissal by reloading form.
	load_form()

```

## Mediation
Follow the steps in [Add ad partners to published GDPR messages](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) to add your mediation partners to the ad partners list. Failure to do so can lead to partners failing to serve ads on your app.

Mediation partners might also have additional tools to help with GDPR compliance. See a specific partner's [integration guide](../../mediate/get_started.md) for more details.


## Troubleshooting

**Error 3.3: The TC string last updated date was more than 13 months ago**

- [Consent must be reobtained](https://support.google.com/admob/answer/9999955#grace-period-2) from the user. You should call `UserMessagingPlatform.consent_information.update()` at the start of every app session. If the TC string is expired, the UMP SDK indicates that consent must be reobtained by setting `ConsentInformation.ConsentStatus` to `ConsentInformation.ConsentStatus.REQUIRED`. If you haven't already, implement a request to [load and present a new UMP form](get_started.md#present-the-form-if-required) in your app.

- It's possible for the TC string to expire mid-session, resulting in a small amount of `3.3` errors. And if on the next app session you start loading ads at the same time as you check `UserMessagingPlatform.consent_information.update()`, those requests could also give `3.3` errors until `UserMessagingPlatform.consent_information.update()` completes; however, this should be a tiny fraction of overall `3.3` errors (less than 0.1%). that are expected.

