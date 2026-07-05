# ConsentInformation

`ConsentInformation` クラスは、現在の同意ステータスの確認、同意情報の更新リクエスト、同意状態のリセットを行うメソッドを提供します。`UserMessagingPlatform.consent_information` (GDScript) または `UserMessagingPlatform.ConsentInformation` (C#) からアクセスします。

## 列挙型

| 列挙型 | 説明 |
| :--- | :--- |
| [ConsentStatus](../enums/ConsentInformation.ConsentStatus.md) | ユーザーの同意ステータスを示します。 |
| [PrivacyOptionsRequirementStatus](../enums/ConsentInformation.PrivacyOptionsRequirementStatus.md) | プライバシーオプションが必要かどうかを示します。 |

## メソッド

### `get_consent_status` / `GetConsentStatus`

現在のユーザーの同意ステータスを返します。

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

同意フォームをロードできるかどうかを返します。

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

ユーザーにプライバシーオプションを提示する必要があるかどうかを返します。

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

指定されたパラメータで同意情報の更新をリクエストします。

=== "GDScript"
    ```gdscript
    func update(
        consent_request: ConsentRequestParameters,
        on_consent_info_updated_success := func(): pass,
        on_consent_info_updated_failure := func(form_error: FormError): pass
    ) -> void
    ```

    **使用法:**
    ```gdscript
    var request_params := ConsentRequestParameters.new()
    request_params.tag_for_under_age_of_consent = false
    
    UserMessagingPlatform.consent_information.update(
        request_params,
        func():
            print("同意情報が正常に更新されました")
        ,
        func(form_error: FormError):
            print("同意情報の更新に失敗: ", form_error.message)
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

    **使用法:**
    ```csharp
    var requestParams = new ConsentRequestParameters();
    requestParams.TagForUnderAgeOfConsent = false;
    
    UserMessagingPlatform.ConsentInformation.Update(
        requestParams,
        () => GD.Print("同意情報が正常に更新されました"),
        (formError) => GD.Print("同意情報の更新に失敗: " + formError.Message)
    );
    ```

---

### `reset` / `Reset`

同意状態を未確定にリセットします。

=== "GDScript"
    ```gdscript
    func reset() -> void
    ```

=== "C#"
    ```csharp
    public void Reset()
    ```
