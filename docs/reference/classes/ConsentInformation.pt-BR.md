# ConsentInformation

A classe `ConsentInformation` fornece métodos para verificar o status atual do consentimento, solicitar atualizações das informações de consentimento e redefinir o estado de consentimento. Acesse-a via `UserMessagingPlatform.consent_information` (GDScript) ou `UserMessagingPlatform.ConsentInformation` (C#).

## Enums

| Enum | Descrição |
| :--- | :--- |
| [ConsentStatus](../enums/ConsentInformation.ConsentStatus.md) | Indica o status de consentimento do usuário. |
| [PrivacyOptionsRequirementStatus](../enums/ConsentInformation.PrivacyOptionsRequirementStatus.md) | Indica se as opções de privacidade são necessárias. |

## Métodos

### `get_consent_status` / `GetConsentStatus`

Retorna o status de consentimento atual do usuário.

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

Retorna se um formulário de consentimento está disponível para carregamento.

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

Retorna se o usuário é obrigado a receber opções de privacidade.

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

Solicita uma atualização das informações de consentimento com os parâmetros fornecidos.

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
            print("Informações de consentimento atualizadas com sucesso")
        ,
        func(form_error: FormError):
            print("Falha ao atualizar informações de consentimento: ", form_error.message)
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
        () => GD.Print("Informações de consentimento atualizadas com sucesso"),
        (formError) => GD.Print("Falha ao atualizar informações de consentimento: " + formError.Message)
    );
    ```

---

### `reset` / `Reset`

Redefine o estado de consentimento para indeterminado.

=== "GDScript"
    ```gdscript
    func reset() -> void
    ```

=== "C#"
    ```csharp
    public void Reset()
    ```
