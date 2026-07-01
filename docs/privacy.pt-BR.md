# Privacidade e Consentimento do Usuário (UMP)

De acordo com as políticas do Google Publisher, os editores devem obter o consentimento dos usuários no Espaço Econômico Europeu (EEE) e no Reino Unido. O SDK do User Messaging Platform (UMP) simplifica esse processo.

---

## Solicitando Atualização de Consentimento

É recomendável solicitar a atualização do status de consentimento a cada inicialização do aplicativo usando `MobileAds.request_user_consent()`.

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("consent_info_update_success", self, "_on_consent_info_update_success")
        MobileAds.connect("consent_info_update_failure", self, "_on_consent_info_update_failure")
        MobileAds.connect("consent_form_dismissed", self, "_on_consent_form_dismissed")
        
        # Solicita ao UMP a verificação de consentimento
        MobileAds.request_user_consent()

    func _on_consent_info_update_success(consent_status_message: String) -> void:
        print("Consentimento atualizado: ", consent_status_message)

    func _on_consent_info_update_failure(error_code: int, error_message: String) -> void:
        print("Erro ao atualizar consentimento: ", error_message)

    func _on_consent_form_dismissed() -> void:
        print("Formulário de consentimento fechado pelo usuário.")
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("consent_info_update_success", this, nameof(_on_consent_info_update_success));
        MobileAds.Connect("consent_info_update_failure", this, nameof(_on_consent_info_update_failure));
        MobileAds.Connect("consent_form_dismissed", this, nameof(_on_consent_form_dismissed));
        
        MobileAds.Call("request_user_consent");
    }

    private void _on_consent_info_update_success(string statusMessage)
    {
        GD.Print("Consentimento atualizado: " + statusMessage);
    }

    private void _on_consent_info_update_failure(int errorCode, string errorMessage)
    {
        GD.Print("Erro ao atualizar consentimento: " + errorMessage);
    }

    private void _on_consent_form_dismissed()
    {
        GD.Print("Formulário de consentimento fechado.");
    }
    ```

---

## Reiniciando o Estado de Consentimento

Para redefinir o estado do UMP para fins de teste, chame `MobileAds.reset_consent_state()`:

=== "GDScript"

    ```gdscript
    MobileAds.reset_consent_state()
    ```

=== "C#"

    ```csharp
    MobileAds.Call("reset_consent_state");
    ```
