# ConsentRequestParameters

The `ConsentRequestParameters` class encapsulates parameters used when requesting a consent information update via [`ConsentInformation.update`](ConsentInformation.md).

## Properties

### `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent`

Whether the user is considered to be under the age of consent for GDPR purposes.

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: bool
    ```

=== "C#"
    ```csharp
    public bool TagForUnderAgeOfConsent { get; set; }
    ```

### `consent_debug_settings` / `ConsentDebugSettings`

Optional debug settings for testing consent flow behavior. See [`ConsentDebugSettings`](ConsentDebugSettings.md).

=== "GDScript"
    ```gdscript
    var consent_debug_settings: ConsentDebugSettings
    ```

=== "C#"
    ```csharp
    public ConsentDebugSettings ConsentDebugSettings { get; set; }
    ```
