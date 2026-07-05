# ConsentForm

La clase `ConsentForm` representa un formulario de consentimiento cargado a través de [`UserMessagingPlatform`](UserMessagingPlatform.md). Muéstrelo al usuario para obtener o actualizar el consentimiento de privacidad.

## Métodos

### `show` / `Show`

Presenta el formulario de consentimiento al usuario. El callback se invoca cuando el formulario se descarta.

=== "GDScript"
    ```gdscript
    func show(on_consent_form_dismissed := func(form_error: FormError): pass) -> void
    ```

    **Uso:**
    ```gdscript
    consent_form.show(
        func(form_error: FormError):
            if form_error:
                print("Formulario de consentimiento descartado con error: ", form_error.message)
            else:
                print("Formulario de consentimiento completado exitosamente")
    )
    ```

=== "C#"
    ```csharp
    public void Show(Action<FormError> onConsentFormDismissed = null)
    ```

    **Uso:**
    ```csharp
    consentForm.Show(
        (formError) => {
            if (formError != null)
                GD.Print("Formulario de consentimiento descartado con error: " + formError.Message);
            else
                GD.Print("Formulario de consentimiento completado exitosamente");
        }
    );
    ```
