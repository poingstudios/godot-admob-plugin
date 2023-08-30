# Enable test ads
This guide provides instructions on enabling test ads in your ad integration. It's crucial to enable test ads during the development phase to allow clicking on them without incurring charges to Google advertisers. Clicking on too many ads without being in test mode may lead to your account being flagged for invalid activity.

To obtain test ads, you have two options:

1. Use Google's [Sample Ad Units](#sample-ad-units).
2. Utilize Your Own Ad Unit and [Enable Test Devices](#enable-test-devices).

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/test-ads)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/test-ads)

## Prerequisites
- Complete the [Get started guide](README.md)

## Sample ad units

The most expedient method to enable testing is by employing Google's provided test ad units. These ad units are separate from your AdMob account, ensuring there is no risk of your account generating invalid traffic while using them.

Please keep in mind that you should select the appropriate Google-provided test ad unit based on the platform you are testing. Use an iOS test ad unit for making test ad requests on iOS and an Android test ad unit for making requests on Android.

!!! note

    **Important Note**: Prior to releasing your app, be certain to substitute these test IDs with your own ad unit ID.

Below are sample ad units for each format available on both Android and iOS:

=== "Android"
    | Ad format             | Sample ad unit ID                      |
    |-----------------------|----------------------------------------|
    | Banner                | ca-app-pub-3940256099942544/6300978111 |
    | Interstitial          | ca-app-pub-3940256099942544/1033173712 |
    | Rewarded              | ca-app-pub-3940256099942544/5224354917 |
    | Rewarded Interstitial | ca-app-pub-3940256099942544/5354046379 |

=== "iOS"

    | Ad format             | Sample ad unit ID                      |
    |-----------------------|----------------------------------------|
    | Banner                | ca-app-pub-3940256099942544/2934735716 |
    | Interstitial          | ca-app-pub-3940256099942544/4411468910 |
    | Rewarded              | ca-app-pub-3940256099942544/1712485313 |
    | Rewarded Interstitial | ca-app-pub-3940256099942544/6978759866 |


## Enable test devices
To conduct more thorough testing with production-like ads, you can configure your device as a test device and utilize your own ad unit IDs created in the AdMob UI. You can add test devices either through the AdMob UI or programmatically using the Google Mobile Ads SDK.

Here are the steps to add your device as a test device:

!!! note

    **Important Note**: Android emulators and iOS simulators are automatically configured as test devices. This means that you can test ads on these virtual devices without needing to manually add them to your test devices list.


### Add your test device in the AdMob UI

For a straightforward, non-programmatic method to include a test device and test new or existing app builds, you can use the AdMob UI. [Here's how](https://support.google.com/admob/answer/9691433).


!!! note

    **Important Note**: Newly added test devices typically begin serving test ads in your app within 15 minutes, although it may also take up to 24 hours for the configuration to take effect.


### Add your test device programmatically

If you wish to test ads within your app during the development phase and want to programmatically register your test device, adhere to the steps below:


1. Open your app with integrated ads and initiate an ad request.
2. Check the logcat output for a message that looks like the one below, which shows you your device ID and how to add it as a test device:

    === "Android"
        ```java
        I/Ads: Use RequestConfiguration.Builder.setTestDeviceIds(Arrays.asList("33BE2250B43518CCDA7DE426D04EE231")) 
        to get test ads on this device."
        ```

    === "iOS"

        ```swift
        <Google> To get test ads on this device, set:
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
        @[ @"2077ef9a63d2b398840261c8221a0c9b" ];
        ```
Copy your test device ID to your clipboard.

3. Update your code to include the test device IDs within your `RequestConfiguration.test_device_ids` array like this:

```gdscript linenums="1" hl_lines="3 4"
func _ready() -> void:
	var request_configuration := RequestConfiguration.new()
	request_configuration.test_device_ids = ["2077ef9a63d2b398840261c8221a0c9b"]
	MobileAds.set_request_configuration(request_configuration)
```
!!! info

    Remember to eliminate the code responsible for defining these test devices prior to releasing your app.

4. Re-launch your app. If the ad is a Google ad, you'll observe a **Test Ad** label positioned at the top center of the ad, whether it's a banner, interstitial, or rewarded video ad:
![testad](https://developers.google.com/static/admob/images/android-testad-0-admob.png)

!!! info
    
    Please note that mediated ads do _NOT_ display a **Test Ad** label. Refer to the section below for further information.


### Testing with mediation

Google's sample ad units exclusively display Google Ads. To test your mediation setup effectively, you must employ the method of [enabling test devices](#enable-test-devices).

Mediated ads do NOT exhibit a "Test Ad" label. Consequently, it is your responsibility to ensure that test ads are enabled for each of your mediation networks to prevent these networks from flagging your account for invalid activity. Refer to each network's individual [mediation guide](mediate/get_started.md) for detailed instructions.

If you are uncertain about whether a mediation ad network adapter supports test ads, it is advisable to refrain from clicking on ads from that network during the development phase. You can utilize the [ResponseInfo.mediation_adapter_class_name](https://github.com/Poing-Studios/godot-admob-plugin/blob/master/addons/admob/src/api/core/ResponseInfo.gd) property within any of the ad formats to determine which ad network served the current ad.