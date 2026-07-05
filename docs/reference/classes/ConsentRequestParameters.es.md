# ConsentRequestParameters

La clase `ConsentRequestParameters` encapsula los parámetros utilizados al solicitar una actualización de la información de consentimiento a través de [`ConsentInformation.update`](ConsentInformation.md).

## Propiedades

### `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent

Si el usuario se considera menor de edad a efectos del GDPR.

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: bool
    ```

=== "C#"
    ```csharp
    public bool TagForUnderAgeOfConsent { get; set; }
    ```

### `consent_debug_settings` / `ConsentDebugSettings`

Configuraciones opcionales de depuración para probar el flujo de consentimiento. Vea [`ConsentDebugSettings`](ConsentDebugSettings.md).

=== "GDScript"
    ```gdscript
    var consent_debug_settings: ConsentDebugSettings
    ```

=== "C#"
    ```csharp
    public ConsentDebugSettings ConsentDebugSettings { get; set; }
    ```
