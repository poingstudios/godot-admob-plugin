# Privacy & User Consent (UMP)

Under the Google Publisher Policies, publishers must comply with Google's EU User Consent Policy when serving ads to users in the European Economic Area (EEA) and the UK. The User Messaging Platform (UMP) SDK simplifies collecting user consent.

---

## Requesting Consent Info Update

It is recommended to request a consent status update on every app launch using `MobileAds.request_user_consent()`.

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("consent_info_update_success", self, "_on_consent_info_update_success")
        MobileAds.connect("consent_info_update_failure", self, "_on_consent_info_update_failure")
        MobileAds.connect("consent_form_dismissed", self, "_on_consent_form_dismissed")
        
        # Requests UMP to check consent state
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

## Resetting Consent State

To reset the UMP state for testing purposes, call `MobileAds.reset_consent_state()`:

=== "GDScript"

    ```gdscript
    MobileAds.reset_consent_state()
    ```

=== "C#"

    ```csharp
    MobileAds.Call("reset_consent_state");
    ```
