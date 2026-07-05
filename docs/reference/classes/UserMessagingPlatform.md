# UserMessagingPlatform

The `UserMessagingPlatform` class provides static methods for loading consent forms and showing privacy options forms in compliance with GDPR and other privacy regulations.

## Static Methods

### `load_consent_form` / `LoadConsentForm`

Loads a consent form asynchronously. The result is delivered via the provided callbacks.

=== "GDScript"
    ```gdscript
    static func load_consent_form(
        on_consent_form_load_success_listener := func(consent_form: ConsentForm): pass,
        on_consent_form_load_failure_listener := func(form_error: FormError): pass
    ) -> void
    ```

    **Usage:**
    ```gdscript
    UserMessagingPlatform.load_consent_form(
        func(consent_form: ConsentForm):
            consent_form.show()
        ,
        func(form_error: FormError):
            print("Failed to load consent form: ", form_error.message)
    )
    ```

=== "C#"
    ```csharp
    public static void LoadConsentForm(
        Action<ConsentForm> onSuccess = null,
        Action<FormError> onFailure = null
    )
    ```

    **Usage:**
    ```csharp
    UserMessagingPlatform.LoadConsentForm(
        (consentForm) => consentForm.Show(),
        (formError) => GD.Print("Failed to load consent form: " + formError.Message)
    );
    ```

---

### `show_privacy_options_form` / `ShowPrivacyOptionsForm`

Displays the privacy options form so the user can change their consent choices.

=== "GDScript"
    ```gdscript
    static func show_privacy_options_form(
        on_privacy_options_form_dismissed := func(form_error: FormError): pass
    ) -> void
    ```

    **Usage:**
    ```gdscript
    UserMessagingPlatform.show_privacy_options_form(
        func(form_error: FormError):
            if form_error:
                print("Privacy options form dismissed with error: ", form_error.message)
            else:
                print("Privacy options form dismissed successfully")
    )
    ```

=== "C#"
    ```csharp
    public static void ShowPrivacyOptionsForm(
        Action<FormError> onPrivacyOptionsFormDismissed = null
    )
    ```

    **Usage:**
    ```csharp
    UserMessagingPlatform.ShowPrivacyOptionsForm(
        (formError) => {
            if (formError != null)
                GD.Print("Privacy options form dismissed with error: " + formError.Message);
            else
                GD.Print("Privacy options form dismissed successfully");
        }
    );
    ```

---

## Static Properties

### `consent_information` / `ConsentInformation`

Provides access to the [`ConsentInformation`](ConsentInformation.md) singleton to check consent status and update consent information.

=== "GDScript"
    ```gdscript
    static var consent_information: ConsentInformation
    ```

=== "C#"
    ```csharp
    public static ConsentInformation ConsentInformation { get; }
    ```
