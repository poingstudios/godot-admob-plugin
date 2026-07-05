# UserMessagingPlatform

`UserMessagingPlatform` 类提供静态方法，用于加载同意表单和显示隐私选项表单，以符合 GDPR 及其他隐私法规。

## 静态方法

### `load_consent_form` / `LoadConsentForm`

异步加载同意表单。结果通过提供的回调函数传递。

=== "GDScript"
    ```gdscript
    static func load_consent_form(
        on_consent_form_load_success_listener := func(consent_form: ConsentForm): pass,
        on_consent_form_load_failure_listener := func(form_error: FormError): pass
    ) -> void
    ```

    **用法:**
    ```gdscript
    UserMessagingPlatform.load_consent_form(
        func(consent_form: ConsentForm):
            consent_form.show()
        ,
        func(form_error: FormError):
            print("加载同意表单失败: ", form_error.message)
    )
    ```

=== "C#"
    ```csharp
    public static void LoadConsentForm(
        Action<ConsentForm> onSuccess = null,
        Action<FormError> onFailure = null
    )
    ```

    **用法:**
    ```csharp
    UserMessagingPlatform.LoadConsentForm(
        (consentForm) => consentForm.Show(),
        (formError) => GD.Print("加载同意表单失败: " + formError.Message)
    );
    ```

---

### `show_privacy_options_form` / `ShowPrivacyOptionsForm`

显示隐私选项表单，以便用户更改其同意选择。

=== "GDScript"
    ```gdscript
    static func show_privacy_options_form(
        on_privacy_options_form_dismissed := func(form_error: FormError): pass
    ) -> void
    ```

    **用法:**
    ```gdscript
    UserMessagingPlatform.show_privacy_options_form(
        func(form_error: FormError):
            if form_error:
                print("隐私选项表单已关闭，出现错误: ", form_error.message)
            else:
                print("隐私选项表单已成功关闭")
    )
    ```

=== "C#"
    ```csharp
    public static void ShowPrivacyOptionsForm(
        Action<FormError> onPrivacyOptionsFormDismissed = null
    )
    ```

    **用法:**
    ```csharp
    UserMessagingPlatform.ShowPrivacyOptionsForm(
        (formError) => {
            if (formError != null)
                GD.Print("隐私选项表单已关闭，出现错误: " + formError.Message);
            else
                GD.Print("隐私选项表单已成功关闭");
        }
    );
    ```

---

## 静态属性

### `consent_information` / `ConsentInformation`

提供对 [`ConsentInformation`](ConsentInformation.md) 单例的访问，用于检查同意状态和更新同意信息。

=== "GDScript"
    ```gdscript
    static var consent_information: ConsentInformation
    ```

=== "C#"
    ```csharp
    public static ConsentInformation ConsentInformation { get; }
    ```
