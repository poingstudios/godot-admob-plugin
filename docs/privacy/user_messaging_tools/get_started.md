# Get started

Under the Google [EU User Consent Policy](https://www.google.com/about/company/user-consent-policy/), you must make certain disclosures to your users in the European Economic Area (EEA) along with the UK and obtain their consent to use cookies or other local storage, where legally required, and to use personal data (such as AdID) to serve ads. This policy reflects the requirements of the EU ePrivacy Directive and the General Data Protection Regulation (GDPR).

To support publishers in meeting their duties under this policy, Google offers the User Messaging Platform (UMP) SDK. The UMP SDK has been updated to support the latest IAB standards. All of these configurations can now conveniently be handled in AdMob privacy & messaging.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/privacy)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/privacy)

## Prerequisites

- Complete the [Get started guide](../../README.md)
- If you're working on GDPR-related requirements, read [How IAB requirements affect EU consent messages](https://support.google.com/admob/answer/10207733).

## Create a message type
Create user messages with one of the [available user message types](https://support.google.com/admob/answer/10114020) under the **Privacy & messaging** tab of your AdMob account. The UMP SDK attempts to display a user message created from the AdMob Application ID set in your project. If no message is configured for your application, the SDK returns an error.

For more details, see [About privacy and messaging](https://support.google.com/admob/answer/10107561).

## Determine if a message needs to be displayed
You should request an update of the user's consent information at every app launch, using `update()` before loading a form. This can determine whether or not your user needs to provide consent if they hadn't done so already or if their consent has expired.

Use the information stored in the consentInformation object when you [present the form](#present-form) when required.

!!! warning
    Using alternative ways of checking the consent status—such as checking a cache your app utilizes or looking for a consent string in storage—are strongly discouraged as the set of ad technology partners could have changed since the user last consented.

Here is an example of how to check the status on app start:

```gdscript
extends Node

func _ready():
	var request := ConsentRequestParameters.new()
    # Set tag for underage of consent. false means users are not underage.
	request.tag_for_under_age_of_consent = false
	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)

func _on_consent_info_updated_success():
	# The consent information state was updated.
	# You are now ready to check if a form is available.
	pass

func _on_consent_info_updated_failure(form_error : FormError):
	# Handle the error.
	pass
```

## Load a form if available

Before displaying a form, you first need to determine if one is available. Unavailable forms can be due to the user enabling limited ad tracking or if you’ve tagged them as under the age of consent.

To check the availability of a form, use the `get_is_consent_form_available()` function on the static `consent_information` instance of `UserMessagingPlatform` class.

Then, add a wrapper function to load the form:

```gdscript
#...
func _on_consent_info_updated_success():
	# The consent information state was updated.
	# You are now ready to check if a form is available.
	if UserMessagingPlatform.consent_information.get_is_consent_form_available():
		load_form()

func _on_consent_info_updated_failure(form_error : FormError):
	# Handle the error.
	pass

func load_form():
	pass
```

To load the form, use the static `load_consent_form()` function on the `UserMessagingPlatform` class.

```gdscript
var _consent_form : ConsentForm

func load_form():
	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)

func _on_consent_form_load_success(consent_form : ConsentForm):
	_consent_form = consent_form

func _on_consent_form_load_failure(form_error : FormError):
	# Handle the error.
	pass
```

## Present the form if required
After you’ve determined the form's availability and loaded it, use the `show()` function on the ConsentForm instance to present the form.

Use the static `consent_information` instance of `UserMessagingPlatform` class to check the consent status and update your `load_form()` function:

```gdscript
var _consent_form : ConsentForm

func load_form():
	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)

func _on_consent_form_load_success(consent_form : ConsentForm):
	_consent_form = consent_form
	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.REQUIRED:
		consent_form.show(_on_consent_form_dismissed)

func _on_consent_form_load_failure(form_error : FormError):
	# Handle the error.
	pass

func _on_consent_form_dismissed(form_error : FormError):
	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.OBTAINED:
		# App can start requesting ads.
		pass
	# Handle dismissal by reloading form
	load_form()
```

If you need to perform any actions after the user has made a choice or dismissed the form, place that logic in the completion handler or callback for your form.

## Testing

### Force a geography

The UMP SDK provides a way to test your app's behavior as though the device was located in the EEA or UK using the `debug_geography` property on `ConsentDebugSettings`.

You must provide your test device's hashed ID in your app's debug settings to use the debug functionality. If you call `UserMessagingPlatform.consent_information.update()` without setting this value, your app logs the required ID hash when run.

```gdscript
extends Node

func _ready():
	var request := ConsentRequestParameters.new()
	var consent_debug_settings := ConsentDebugSettings.new()
	consent_debug_settings.debug_geography = DebugGeography.Values.EEA
	consent_debug_settings.test_device_hashed_ids.append("test_device_hashed_id")
	request.consent_debug_settings = consent_debug_settings
	
	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)

func _on_consent_info_updated_success():
	# The consent information state was updated.
	# You are now ready to check if a form is available.
	pass

func _on_consent_info_updated_failure(form_error : FormError):
	# Handle the error.
	pass
```

With the `DebugGeography.Values` enum, you have the option to force the geography to one of these options:

| DebugGeography | Description                                            |
|----------------|--------------------------------------------------------|
| DISABLED       | Debug geography disabled.                              |
| EEA            | Geography appears as in EEA for debug devices.         |
| NOT_EEA        | Geography appears as not in the EEA for debug devices. |

Note that debug settings only work on test devices. Emulators don't need to be added to your device ID list as they already have testing enabled by default.


### Reset consent state

In testing your app with the UMP SDK, you might find it helpful to reset the state of the SDK so that you can simulate a user's first install experience. The SDK provides the `reset()` function to do this.

```gdscript
UserMessagingPlatform.consent_information.reset()
```

You should also call `reset()` if you decide to remove the UMP SDK completely from your project.

!!! warning
    This function is intended to be used for testing purposes only. You shouldn't call `reset()` in production code.
