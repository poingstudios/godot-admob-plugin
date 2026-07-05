# ConsentInformation

The `ConsentInformation` class provides methods to check the current consent status, request consent information updates, and reset consent state. Access it via `UserMessagingPlatform.consent_information` (GDScript) or `UserMessagingPlatform.ConsentInformation` (C#).

## Enums

| Enum | Description |
| :--- | :--- |
| [ConsentStatus](../enums/ConsentInformation.ConsentStatus.md) | Indicates the user's consent status. |
| [PrivacyOptionsRequirementStatus](../enums/ConsentInformation.PrivacyOptionsRequirementStatus.md) | Indicates whether privacy options are required. |

## Methods

### `get_consent_status` / `GetConsentStatus`

Returns the current consent status of the user.

=== "GDScript"
    ```gdscript
    func get_consent_status() -> ConsentStatus
    ```

=== "C#"
    ```csharp
    public ConsentStatus GetConsentStatus()
    ```

---

### `get_is_consent_form_available` / `GetIsConsentFormAvailable`

Returns whether a consent form is available to load.

=== "GDScript"
    ```gdscript
    func get_is_consent_form_available() -> bool
    ```

=== "C#"
    ```csharp
    public bool GetIsConsentFormAvailable()
    ```

---

### `get_privacy_options_requirement_status` / `GetPrivacyOptionsRequirementStatus`

Returns whether the user is required to be presented with privacy options.

=== "GDScript"
    ```gdscript
    func get_privacy_options_requirement_status() -> PrivacyOptionsRequirementStatus
    ```

=== "C#"
    ```csharp
    public PrivacyOptionsRequirementStatus GetPrivacyOptionsRequirementStatus()
    ```

---

### `update` / `Update`

Requests a consent information update with the given parameters.

=== "GDScript"
    ```gdscript
    func update(
        consent_request: ConsentRequestParameters,
        on_consent_info_updated_success := func(): pass,
        on_consent_info_updated_failure := func(form_error: FormError): pass
    ) -> void
    ```

    **Usage:**
    ```gdscript
    var request_params := ConsentRequestParameters.new()
    request_params.tag_for_under_age_of_consent = false
    
    UserMessagingPlatform.consent_information.update(
        request_params,
        func():
            print("Consent info updated successfully")
        ,
        func(form_error: FormError):
            print("Failed to update consent info: ", form_error.message)
    )
    ```

=== "C#"
    ```csharp
    public void Update(
        ConsentRequestParameters consentRequest,
        Action onSuccess = null,
        Action<FormError> onFailure = null
    )
    ```

    **Usage:**
    ```csharp
    var requestParams = new ConsentRequestParameters();
    requestParams.TagForUnderAgeOfConsent = false;
    
    UserMessagingPlatform.ConsentInformation.Update(
        requestParams,
        () => GD.Print("Consent info updated successfully"),
        (formError) => GD.Print("Failed to update consent info: " + formError.Message)
    );
    ```

---

### `reset` / `Reset`

Resets the consent state to undetermined.

=== "GDScript"
    ```gdscript
    func reset() -> void
    ```

=== "C#"
    ```csharp
    public void Reset()
    ```
