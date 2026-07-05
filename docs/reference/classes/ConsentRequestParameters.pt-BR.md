# ConsentRequestParameters

A classe `ConsentRequestParameters` encapsula os parâmetros usados ao solicitar uma atualização das informações de consentimento via [`ConsentInformation.update`](ConsentInformation.md).

## Propriedades

### `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent

Se o usuário é considerado menor de idade para fins de GDPR.

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: bool
    ```

=== "C#"
    ```csharp
    public bool TagForUnderAgeOfConsent { get; set; }
    ```

### `consent_debug_settings` / `ConsentDebugSettings`

Configurações opcionais de depuração para testar o fluxo de consentimento. Veja [`ConsentDebugSettings`](ConsentDebugSettings.md).

=== "GDScript"
    ```gdscript
    var consent_debug_settings: ConsentDebugSettings
    ```

=== "C#"
    ```csharp
    public ConsentDebugSettings ConsentDebugSettings { get; set; }
    ```
