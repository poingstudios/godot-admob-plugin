# ConsentForm

A classe `ConsentForm` representa um formulário de consentimento carregado via [`UserMessagingPlatform`](UserMessagingPlatform.md). Exiba-o ao usuário para obter ou atualizar o consentimento de privacidade.

## Métodos

### `show` / `Show`

Apresenta o formulário de consentimento ao usuário. O callback é invocado quando o formulário é dispensado.

=== "GDScript"
    ```gdscript
    func show(on_consent_form_dismissed := func(form_error: FormError): pass) -> void
    ```

    **Uso:**
    ```gdscript
    consent_form.show(
        func(form_error: FormError):
            if form_error:
                print("Formulário de consentimento dispensado com erro: ", form_error.message)
            else:
                print("Formulário de consentimento concluído com sucesso")
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
                GD.Print("Formulário de consentimento dispensado com erro: " + formError.Message);
            else
                GD.Print("Formulário de consentimento concluído com sucesso");
        }
    );
    ```
