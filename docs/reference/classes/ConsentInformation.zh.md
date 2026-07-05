# ConsentInformation

`ConsentInformation` 类提供检查当前同意状态、请求同意信息更新以及重置同意状态的方法。通过 `UserMessagingPlatform.consent_information` (GDScript) 或 `UserMessagingPlatform.ConsentInformation` (C#) 访问。

## 枚举

| 枚举 | 描述 |
| :--- | :--- |
| [ConsentStatus](../enums/ConsentInformation.ConsentStatus.md) | 指示用户的同意状态。 |
| [PrivacyOptionsRequirementStatus](../enums/ConsentInformation.PrivacyOptionsRequirementStatus.md) | 指示是否需要隐私选项。 |

## 方法

### `get_consent_status` / `GetConsentStatus`

返回用户当前的同意状态。

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

返回是否有可用的同意表单可供加载。

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

返回用户是否需要显示隐私选项。

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

使用提供的参数请求同意信息更新。

=== "GDScript"
    ```gdscript
    func update(
        consent_request: ConsentRequestParameters,
        on_consent_info_updated_success := func(): pass,
        on_consent_info_updated_failure := func(form_error: FormError): pass
    ) -> void
    ```

    **用法:**
    ```gdscript
    var request_params := ConsentRequestParameters.new()
    request_params.tag_for_under_age_of_consent = false
    
    UserMessagingPlatform.consent_information.update(
        request_params,
        func():
            print("同意信息更新成功")
        ,
        func(form_error: FormError):
            print("更新同意信息失败: ", form_error.message)
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

    **用法:**
    ```csharp
    var requestParams = new ConsentRequestParameters();
    requestParams.TagForUnderAgeOfConsent = false;
    
    UserMessagingPlatform.ConsentInformation.Update(
        requestParams,
        () => GD.Print("同意信息更新成功"),
        (formError) => GD.Print("更新同意信息失败: " + formError.Message)
    );
    ```

---

### `reset` / `Reset`

将同意状态重置为未确定。

=== "GDScript"
    ```gdscript
    func reset() -> void
    ```

=== "C#"
    ```csharp
    public void Reset()
    ```
