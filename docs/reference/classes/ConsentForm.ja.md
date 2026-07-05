# ConsentForm

`ConsentForm` クラスは、[`UserMessagingPlatform`](UserMessagingPlatform.md) を介してロードされた同意フォームを表します。ユーザーに表示してプライバシーの同意を取得または更新します。

## メソッド

### `show` / `Show`

同意フォームをユーザーに表示します。フォームが閉じられたときにコールバックが呼び出されます。

=== "GDScript"
    ```gdscript
    func show(on_consent_form_dismissed := func(form_error: FormError): pass) -> void
    ```

    **使用法:**
    ```gdscript
    consent_form.show(
        func(form_error: FormError):
            if form_error:
                print("同意フォームがエラーで閉じられました: ", form_error.message)
            else:
                print("同意フォームが正常に完了しました")
    )
    ```

=== "C#"
    ```csharp
    public void Show(Action<FormError> onConsentFormDismissed = null)
    ```

    **使用法:**
    ```csharp
    consentForm.Show(
        (formError) => {
            if (formError != null)
                GD.Print("同意フォームがエラーで閉じられました: " + formError.Message);
            else
                GD.Print("同意フォームが正常に完了しました");
        }
    );
    ```
