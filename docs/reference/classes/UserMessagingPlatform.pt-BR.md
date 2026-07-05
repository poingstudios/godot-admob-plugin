# UserMessagingPlatform

A classe `UserMessagingPlatform` fornece métodos estáticos para carregar formulários de consentimento e exibir formulários de opções de privacidade em conformidade com o GDPR e outros regulamentos de privacidade.

## Métodos Estáticos

### `load_consent_form` / `LoadConsentForm`

Carrega um formulário de consentimento de forma assíncrona. O resultado é entregue através dos callbacks fornecidos.

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
            print("Falha ao carregar formulário de consentimento: ", form_error.message)
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
        (formError) => GD.Print("Falha ao carregar formulário de consentimento: " + formError.Message)
    );
    ```

---

### `show_privacy_options_form` / `ShowPrivacyOptionsForm`

Exibe o formulário de opções de privacidade para que o usuário possa alterar suas escolhas de consentimento.

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
                print("Formulário de opções de privacidade dispensado com erro: ", form_error.message)
            else:
                print("Formulário de opções de privacidade dispensado com sucesso")
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
                GD.Print("Formulário de opções de privacidade dispensado com erro: " + formError.Message);
            else
                GD.Print("Formulário de opções de privacidade dispensado com sucesso");
        }
    );
    ```

---

## Propriedades Estáticas

### `consent_information` / `ConsentInformation`

Fornece acesso ao singleton [`ConsentInformation`](ConsentInformation.md) para verificar o status do consentimento e atualizar as informações de consentimento.

=== "GDScript"
    ```gdscript
    static var consent_information: ConsentInformation
    ```

=== "C#"
    ```csharp
    public static ConsentInformation ConsentInformation { get; }
    ```
