# ConsentRequestParameters

`ConsentRequestParameters` クラスは、[`ConsentInformation.update`](ConsentInformation.md) を介して同意情報の更新をリクエストする際に使用されるパラメータをカプセル化します。

## プロパティ

### `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent`

ユーザーがGDPRの同意年齢に達していないと見なされるかどうか。

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: bool
    ```

=== "C#"
    ```csharp
    public bool TagForUnderAgeOfConsent { get; set; }
    ```

### `consent_debug_settings` / `ConsentDebugSettings`

同意フローをテストするためのオプションのデバッグ設定。[`ConsentDebugSettings`](ConsentDebugSettings.md) を参照してください。

=== "GDScript"
    ```gdscript
    var consent_debug_settings: ConsentDebugSettings
    ```

=== "C#"
    ```csharp
    public ConsentDebugSettings ConsentDebugSettings { get; set; }
    ```
