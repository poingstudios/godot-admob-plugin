# UserMessagingPlatform

`UserMessagingPlatform` クラスは、GDPRやその他のプライバシー規制に準拠するために、同意フォームのロードおよびプライバシーオプションフォームの表示を行う静的メソッドを提供します。

## 静的メソッド

### `load_consent_form` / `LoadConsentForm`

同意フォームを非同期でロードします。結果は提供されたコールバックを通じて配信されます。

=== "GDScript"
    ```gdscript
    static func load_consent_form(
        on_consent_form_load_success_listener := func(consent_form: ConsentForm): pass,
        on_consent_form_load_failure_listener := func(form_error: FormError): pass
    ) -> void
    ```

    **使用法:**
    ```gdscript
    UserMessagingPlatform.load_consent_form(
        func(consent_form: ConsentForm):
            consent_form.show()
        ,
        func(form_error: FormError):
            print("同意フォームの読み込みに失敗: ", form_error.message)
    )
    ```

=== "C#"
    ```csharp
    public static void LoadConsentForm(
        Action<ConsentForm> onSuccess = null,
        Action<FormError> onFailure = null
    )
    ```

    **使用法:**
    ```csharp
    UserMessagingPlatform.LoadConsentForm(
        (consentForm) => consentForm.Show(),
        (formError) => GD.Print("同意フォームの読み込みに失敗: " + formError.Message)
    );
    ```

---

### `show_privacy_options_form` / `ShowPrivacyOptionsForm`

プライバシーオプションフォームを表示し、ユーザーが同意の選択を変更できるようにします。

=== "GDScript"
    ```gdscript
    static func show_privacy_options_form(
        on_privacy_options_form_dismissed := func(form_error: FormError): pass
    ) -> void
    ```

    **使用法:**
    ```gdscript
    UserMessagingPlatform.show_privacy_options_form(
        func(form_error: FormError):
            if form_error:
                print("プライバシーオプションフォームがエラーで閉じられました: ", form_error.message)
            else:
                print("プライバシーオプションフォームが正常に閉じられました")
    )
    ```

=== "C#"
    ```csharp
    public static void ShowPrivacyOptionsForm(
        Action<FormError> onPrivacyOptionsFormDismissed = null
    )
    ```

    **使用法:**
    ```csharp
    UserMessagingPlatform.ShowPrivacyOptionsForm(
        (formError) => {
            if (formError != null)
                GD.Print("プライバシーオプションフォームがエラーで閉じられました: " + formError.Message);
            else
                GD.Print("プライバシーオプションフォームが正常に閉じられました");
        }
    );
    ```

---

## 静的プロパティ

### `consent_information` / `ConsentInformation`

同意ステータスを確認し、同意情報を更新するための [`ConsentInformation`](ConsentInformation.md) シングルトンへのアクセスを提供します。

=== "GDScript"
    ```gdscript
    static var consent_information: ConsentInformation
    ```

=== "C#"
    ```csharp
    public static ConsentInformation ConsentInformation { get; }
    ```
