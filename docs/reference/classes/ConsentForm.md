# ConsentForm

The `ConsentForm` class represents a consent form loaded via [`UserMessagingPlatform`](UserMessagingPlatform.md). Display it to the user to obtain or update privacy consent.

## Methods

### `show` / `Show`

Presents the consent form to the user. The callback is invoked when the form is dismissed.

=== "GDScript"
    ```gdscript
    func show(on_consent_form_dismissed := func(form_error: FormError): pass) -> void
    ```

    **Usage:**
    ```gdscript
    consent_form.show(
        func(form_error: FormError):
            if form_error:
                print("Consent form dismissed with error: ", form_error.message)
            else:
                print("Consent form completed successfully")
    )
    ```

=== "C#"
    ```csharp
    public void Show(Action<FormError> onConsentFormDismissed = null)
    ```

    **Usage:**
    ```csharp
    consentForm.Show(
        (formError) => {
            if (formError != null)
                GD.Print("Consent form dismissed with error: " + formError.Message);
            else
                GD.Print("Consent form completed successfully");
        }
    );
    ```
