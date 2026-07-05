# ConsentRequestParameters

`ConsentRequestParameters` 类封装了通过 [`ConsentInformation.update`](ConsentInformation.md) 请求同意信息更新时使用的参数。

## 属性

### `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent`

用户是否被视为未达到 GDPR 同意年龄。

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: bool
    ```

=== "C#"
    ```csharp
    public bool TagForUnderAgeOfConsent { get; set; }
    ```

### `consent_debug_settings` / `ConsentDebugSettings`

用于测试同意流程的可选调试设置。参见 [`ConsentDebugSettings`](ConsentDebugSettings.md)。

=== "GDScript"
    ```gdscript
    var consent_debug_settings: ConsentDebugSettings
    ```

=== "C#"
    ```csharp
    public ConsentDebugSettings ConsentDebugSettings { get; set; }
    ```
