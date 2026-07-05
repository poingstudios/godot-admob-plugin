# RequestConfiguration

The `RequestConfiguration` class aggregates global ad request settings applied to every ad load.

## Constants

### Device ID Emulator

Use this constant to enable test ads on emulators.

=== "GDScript"
    ```gdscript
    RequestConfiguration.DEVICE_ID_EMULATOR
    ```

=== "C#"
    ```csharp
    RequestConfiguration.DeviceIdEmulator
    ```

### Max Ad Content Ratings

Configure content filters for ads loaded by the app.

=== "GDScript"
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_UNSPECIFIED`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_G`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_PG`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_T`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_MA`

=== "C#"
    - `RequestConfiguration.MaxAdContentRatingUnspecified`
    - `RequestConfiguration.MaxAdContentRatingG`
    - `RequestConfiguration.MaxAdContentRatingPG`
    - `RequestConfiguration.MaxAdContentRatingT`
    - `RequestConfiguration.MaxAdContentRatingMA`

---

## Properties

### `max_ad_content_rating` / `MaxAdContentRating`

The maximum ad content rating allowed for ads served to the app.

=== "GDScript"
    ```gdscript
    var max_ad_content_rating: String
    ```

=== "C#"
    ```csharp
    public string MaxAdContentRating { get; set; }
    ```

### `tag_for_child_directed_treatment` / `ChildDirectedTreatment`

Configures the child-directed treatment setting for COPPA compliance.

=== "GDScript"
    ```gdscript
    var tag_for_child_directed_treatment: int # Matches values from TagForChildDirectedTreatment enum
    ```

=== "C#"
    ```csharp
    public TagForChildDirectedTreatment ChildDirectedTreatment { get; set; }
    ```

### `tag_for_under_age_of_consent` / `UnderAgeOfConsent`

Configures the under age of consent setting for GDPR compliance.

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: int # Matches values from TagForUnderAgeOfConsent enum
    ```

=== "C#"
    ```csharp
    public TagForUnderAgeOfConsent UnderAgeOfConsent { get; set; }
    ```

### `test_device_ids` / `TestDeviceIds`

A list of test device IDs to receive test ads.

=== "GDScript"
    ```gdscript
    var test_device_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceIds { get; set; }
    ```
