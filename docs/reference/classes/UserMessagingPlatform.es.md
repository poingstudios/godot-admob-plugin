# UserMessagingPlatform

La clase `UserMessagingPlatform` proporciona métodos estáticos para cargar formularios de consentimiento y mostrar formularios de opciones de privacidad en cumplimiento con el GDPR y otras regulaciones de privacidad.

## Métodos Estáticos

### `load_consent_form` / `LoadConsentForm`

Carga un formulario de consentimiento de forma asíncrona. El resultado se entrega a través de los callbacks proporcionados.

=== "GDScript"
    ```gdscript
    static func load_consent_form(
        on_consent_form_load_success_listener := func(consent_form: ConsentForm): pass,
        on_consent_form_load_failure_listener := func(form_error: FormError): pass
    ) -> void
    ```

    **Uso:**
    ```gdscript
    UserMessagingPlatform.load_consent_form(
        func(consent_form: ConsentForm):
            consent_form.show()
        ,
        func(form_error: FormError):
            print("Error al cargar el formulario de consentimiento: ", form_error.message)
    )
    ```

=== "C#"
    ```csharp
    public static void LoadConsentForm(
        Action<ConsentForm> onSuccess = null,
        Action<FormError> onFailure = null
    )
    ```

    **Uso:**
    ```csharp
    UserMessagingPlatform.LoadConsentForm(
        (consentForm) => consentForm.Show(),
        (formError) => GD.Print("Error al cargar el formulario de consentimiento: " + formError.Message)
    );
    ```

---

### `show_privacy_options_form` / `ShowPrivacyOptionsForm`

Muestra el formulario de opciones de privacidad para que el usuario pueda cambiar sus opciones de consentimiento.

=== "GDScript"
    ```gdscript
    static func show_privacy_options_form(
        on_privacy_options_form_dismissed := func(form_error: FormError): pass
    ) -> void
    ```

    **Uso:**
    ```gdscript
    UserMessagingPlatform.show_privacy_options_form(
        func(form_error: FormError):
            if form_error:
                print("Formulario de opciones de privacidad descartado con error: ", form_error.message)
            else:
                print("Formulario de opciones de privacidad descartado exitosamente")
    )
    ```

=== "C#"
    ```csharp
    public static void ShowPrivacyOptionsForm(
        Action<FormError> onPrivacyOptionsFormDismissed = null
    )
    ```

    **Uso:**
    ```csharp
    UserMessagingPlatform.ShowPrivacyOptionsForm(
        (formError) => {
            if (formError != null)
                GD.Print("Formulario de opciones de privacidad descartado con error: " + formError.Message);
            else
                GD.Print("Formulario de opciones de privacidad descartado exitosamente");
        }
    );
    ```

---

## Propiedades Estáticas

### `consent_information` / `ConsentInformation`

Proporciona acceso al singleton [`ConsentInformation`](ConsentInformation.md) para verificar el estado del consentimiento y actualizar la información de consentimiento.

=== "GDScript"
    ```gdscript
    static var consent_information: ConsentInformation
    ```

=== "C#"
    ```csharp
    public static ConsentInformation ConsentInformation { get; }
    ```
