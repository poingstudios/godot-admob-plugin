# 隐私和用户同意（UMP）

!!! note "Godot 3 (v1) 文档"
    本页面适用于 **Godot 3.x**。如需 **Godot 4.2+**，请查看[稳定文档](https://poingstudios.github.io/godot-admob-plugin/stable/)。

根据Google发布商政策，向欧洲经济区（EEA）和英国的用户提供广告时，发布商必须遵守Google的欧盟用户同意政策。用户消息平台（UMP）SDK简化了用户同意的收集。

---

## 请求同意信息更新

建议在每次应用启动时使用`MobileAds.request_user_consent()`请求同意状态更新。

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("consent_info_update_success", self, "_on_consent_info_update_success")
        MobileAds.connect("consent_info_update_failure", self, "_on_consent_info_update_failure")
        MobileAds.connect("consent_form_dismissed", self, "_on_consent_form_dismissed")
        
        # 请求UMP检查同意状态
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

## 重置同意状态

要出于测试目的重置UMP状态，请调用`MobileAds.reset_consent_state()`：

=== "GDScript"

    ```gdscript
    MobileAds.reset_consent_state()
    ```

=== "C#"

    ```csharp
    MobileAds.Call("reset_consent_state");
    ```