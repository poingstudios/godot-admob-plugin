# プライバシーとユーザー同意（UMP）

Google公開者ポリシーによると、欧州経済領域（EEA）および英国のユーザーに広告を提供する際、公開者はGoogleのEUユーザー同意ポリシーに準拠する必要があります。ユーザーメッセージングプラットフォーム（UMP）SDKは、ユーザーの同意収集を簡素化します。

---

## 同意情報更新のリクエスト

アプリの起動時に`MobileAds.request_user_consent()`を使用して、同意ステータスの更新をリクエストすることをお勧めします。

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("consent_info_update_success", self, "_on_consent_info_update_success")
        MobileAds.connect("consent_info_update_failure", self, "_on_consent_info_update_failure")
        MobileAds.connect("consent_form_dismissed", self, "_on_consent_form_dismissed")
        
        # UMPに同意ステータスの確認をリクエスト
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

## 同意ステータスのリセット

テスト目的でUMPステータスをリセットするには、`MobileAds.reset_consent_state()`を呼びます：

=== "GDScript"

    ```gdscript
    MobileAds.reset_consent_state()
    ```

=== "C#"

    ```csharp
    MobileAds.Call("reset_consent_state");
    ```