# Global Settings

The `MobileAds` class provides global settings for Google Mobile Ads SDK.

## Video ad volume control

If your app has its own volume controls, such as custom music or sound effect volumes, disclosing app volume to Google Mobile Ads SDK enables video ads to respect app volume settings. This ensures users receive video ads with the expected audio volume.

The device volume, controlled through volume buttons or OS-level volume slider, determines the volume for device audio output. However, apps can independently adjust volume levels relative to the device volume to tailor the audio experience.

You can report the relative app volume to Google Mobile Ads SDK by calling the `set_app_volume()` method before loading the ad. Valid ad volume values range from `0.0` (silent) to `1.0` (current device volume). Here's an example of how to report the relative app volume to the SDK:

=== "GDScript"

    ```gdscript
    # Set app volume to be half of current device volume.
    MobileAds.set_app_volume(0.5)
    ```

=== "C#"

    ```csharp
    // Set app volume to be half of current device volume.
    MobileAds.SetAppVolume(0.5f);
    ```

!!! warning
    Lowering your app's audio volume reduces video ad eligibility and might reduce your app's ad revenue. You should only utilize this method if your app provides custom volume controls to the user, and the user's volume is properly reflected in the app.

To inform the SDK that the app volume has been muted, call the `set_app_muted()` method before loading the ad:

=== "GDScript"

    ```gdscript
    # Set app to be muted.
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // Set app to be muted.
    MobileAds.SetAppMuted(true);
    ```

By default, the app volume is set to `1`, the current device volume, and the app is not muted.

!!! warning
    Muting your app reduces video ad eligibility and might reduce your app's ad revenue. You should only utilize this method if your app provides a custom mute control to the user, and the user's mute decision is properly reflected in the app.

## Consent for cookies

If your app has special requirements, you can set the optional `gad_has_consent_for_cookies` key to zero to enable [limited ads](https://support.google.com/admob/answer/10105530):

=== "GDScript"

    ```gdscript
    # Enable limited ads
    MobileAds.set_gad_has_consent_for_cookies(false)
    ```

=== "C#"

    ```csharp
    // Enable limited ads
    MobileAds.SetGadHasConsentForCookies(false);
    ```

## Disable crash reporting

Google Mobile Ads SDK collects crash reports for debugging and analysis purposes. To disable crash reporting, see the following sections for Android and iOS.

=== "Android"

    Add the `<meta-data>` tag with `DISABLE_CRASH_REPORTING` set to `true` in your app's `AndroidManifest.xml` file:

    ```xml
    <manifest>
       <application>
           <meta-data
               android:name="com.google.android.gms.ads.flag.DISABLE_CRASH_REPORTING"
               android:value="true" />
       </application>
    </manifest>
    ```

=== "iOS"

    Call the `disable_sdk_crash_reporting()` method to disable crash reports on iOS:

    === "GDScript"

        ```gdscript
        func _ready() -> void:
            MobileAds.disable_sdk_crash_reporting()
        ```

    === "C#"

        ```csharp
        public override void _Ready()
        {
            MobileAds.DisableSdkCrashReporting();
        }
        ```

## Get plugin version

To get the plugin version, run the following:

=== "GDScript"

    ```gdscript
    # Get the plugin version.
    print("Plugin Version: " + MobileAds.get_version())
    ```

=== "C#"

    ```csharp
    // Get the plugin version.
    GD.Print("Plugin Version: " + MobileAds.GetVersion());
    ```

## Get platform version

The Google Mobile Ads SDK depends on the Android and iOS platform SDKs. To get the version of the platform SDK, run the following:

=== "GDScript"

    ```gdscript
    # Get the underlying platform SDK version.
    print("Platform SDK Version: " + MobileAds.get_platform_version())
    ```

=== "C#"

    ```csharp
    // Get the underlying platform SDK version.
    GD.Print("Platform SDK Version: " + MobileAds.GetPlatformVersion());
    ```
