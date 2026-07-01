# Privacidad y Consentimiento del Usuario (UMP)

Según las Políticas de Publicación de Google, los editores deben cumplir con la Política de Consentimiento de Usuario de Google de la UE al servir anuncios a usuarios en el Espacio Económico Europeo (EEE) y el Reino Unido. La plataforma de Mensajes del Usuario (UMP) SDK simplifica la recopilación del consentimiento del usuario.

---

## Solicitar Actualización de Información de Consentimiento

Se recomienda solicitar una actualización del estado de consentimiento en cada inicio de la aplicación usando `MobileAds.request_user_consent()`.

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("consent_info_update_success", self, "_on_consent_info_update_success")
        MobileAds.connect("consent_info_update_failure", self, "_on_consent_info_update_failure")
        MobileAds.connect("consent_form_dismissed", self, "_on_consent_form_dismissed")
        
        # Solicita a UMP verificar el estado de consentimiento
        MobileAds.request_user_consent()

    func _on_consent_info_update_success(consent_status_message: String) -> void:
        print("Consent info updated: ", consent_status_message)

    func _on_consent_info_update_failure(error_code: int, error_message: String) -> void:
        print("Failed to update consent info: ", error_message)

    func _on_consent_form_dismissed() -> void:
        print("Consent form was dismissed by the user.")
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
        GD.Print("Consent info updated: " + statusMessage);
    }

    private void _on_consent_info_update_failure(int errorCode, string errorMessage)
    {
        GD.Print("Consent update failed: " + errorMessage);
    }

    private void _on_consent_form_dismissed()
    {
        GD.Print("Consent form dismissed.");
    }
    ```

---

## Restablecer Estado de Consentimiento

Para restablecer el estado de UMP con fines de prueba, llama a `MobileAds.reset_consent_state()`:

=== "GDScript"

    ```gdscript
    MobileAds.reset_consent_state()
    ```

=== "C#"

    ```csharp
    MobileAds.Call("reset_consent_state");
    ```