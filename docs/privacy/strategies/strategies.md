# Privacy strategies

!!! note
    **Important**: Please verify you have **Account Management** permission to complete privacy strategy configuration. To learn more please see the following [new user roles](https://support.google.com/admob/answer/2784628) article.

This guide explains privacy strategies available in the Google Mobile Ads SDK to help you deliver more relevant ads while respecting user privacy.

This document is based on:

- [Google Mobile Ads SDK Android - Privacy Strategies](https://developers.google.com/admob/android/privacy/strategies)
- [Google Mobile Ads SDK iOS - Privacy Strategies](https://developers.google.com/admob/ios/privacy/strategies)

## Publisher first-party ID

The Google Mobile Ads SDK introduced Publisher first-party ID to help you deliver more relevant and personalized ads by using data collected from your apps.

Publisher first-party ID is enabled by default, but you can disable it using the following methods.

=== "GDScript"

    ```gdscript
    # Disables Publisher first-party ID.
    MobileAds.set_publisher_first_party_id_enabled(false)
    ```

=== "C#"

    ```csharp
    // Disables Publisher first-party ID.
    MobileAds.SetPublisherFirstPartyIDEnabled(false);
    ```

!!! note
    **Tip:** Publisher first-party ID requires Google Mobile Ads SDK version 22.6.0 or higher for Android, and 10.14.0 or higher for iOS.
