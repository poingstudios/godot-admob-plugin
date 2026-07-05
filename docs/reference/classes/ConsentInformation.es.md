# ConsentInformation

La clase `ConsentInformation` proporciona métodos para verificar el estado actual del consentimiento, solicitar actualizaciones de la información de consentimiento y restablecer el estado de consentimiento. Acceda a través de `UserMessagingPlatform.consent_information` (GDScript) o `UserMessagingPlatform.ConsentInformation` (C#).

## Enumeraciones

| Enum | Descripción |
| :--- | :--- |
| [ConsentStatus](../enums/ConsentInformation.ConsentStatus.md) | Indica el estado de consentimiento del usuario. |
| [PrivacyOptionsRequirementStatus](../enums/ConsentInformation.PrivacyOptionsRequirementStatus.md) | Indica si se requieren opciones de privacidad. |

## Métodos

### `get_consent_status` / `GetConsentStatus`

Devuelve el estado de consentimiento actual del usuario.

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

Devuelve si hay un formulario de consentimiento disponible para cargar.

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

Devuelve si el usuario debe recibir opciones de privacidad.

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

Solicita una actualización de la información de consentimiento con los parámetros proporcionados.

=== "GDScript"
    ```gdscript
    func update(
        consent_request: ConsentRequestParameters,
        on_consent_info_updated_success := func(): pass,
        on_consent_info_updated_failure := func(form_error: FormError): pass
    ) -> void
    ```

    **Uso:**
    ```gdscript
    var request_params := ConsentRequestParameters.new()
    request_params.tag_for_under_age_of_consent = false
    
    UserMessagingPlatform.consent_information.update(
        request_params,
        func():
            print("Información de consentimiento actualizada exitosamente")
        ,
        func(form_error: FormError):
            print("Error al actualizar la información de consentimiento: ", form_error.message)
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

    **Uso:**
    ```csharp
    var requestParams = new ConsentRequestParameters();
    requestParams.TagForUnderAgeOfConsent = false;
    
    UserMessagingPlatform.ConsentInformation.Update(
        requestParams,
        () => GD.Print("Información de consentimiento actualizada exitosamente"),
        (formError) => GD.Print("Error al actualizar la información de consentimiento: " + formError.Message)
    );
    ```

---

### `reset` / `Reset`

Restablece el estado de consentimiento a indeterminado.

=== "GDScript"
    ```gdscript
    func reset() -> void
    ```

=== "C#"
    ```csharp
    public void Reset()
    ```
