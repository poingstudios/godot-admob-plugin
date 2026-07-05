# ConsentForm

`ConsentForm` 类表示通过 [`UserMessagingPlatform`](UserMessagingPlatform.md) 加载的同意表单。向用户显示以获取或更新隐私同意。

## 方法

### `show` / `Show`

向用户显示同意表单。表单关闭时调用回调函数。

=== "GDScript"
    ```gdscript
    func show(on_consent_form_dismissed := func(form_error: FormError): pass) -> void
    ```

    **用法:**
    ```gdscript
    consent_form.show(
        func(form_error: FormError):
            if form_error:
                print("同意表单已关闭，出现错误: ", form_error.message)
            else:
                print("同意表单已成功完成")
    )
    ```

=== "C#"
    ```csharp
    public void Show(Action<FormError> onConsentFormDismissed = null)
    ```

    **用法:**
    ```csharp
    consentForm.Show(
        (formError) => {
            if (formError != null)
                GD.Print("同意表单已关闭，出现错误: " + formError.Message);
            else
                GD.Print("同意表单已成功完成");
        }
    );
    ```
