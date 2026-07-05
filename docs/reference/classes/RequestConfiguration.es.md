# RequestConfiguration

La clase `RequestConfiguration` agrega configuraciones globales de solicitud de anuncio aplicadas a cada carga de anuncio.

## Constantes

### Device ID Emulator

Use esta constante para habilitar anuncios de prueba en emuladores.

=== "GDScript"
    ```gdscript
    RequestConfiguration.DEVICE_ID_EMULATOR
    ```

=== "C#"
    ```csharp
    RequestConfiguration.DeviceIdEmulator
    ```

### Max Ad Content Ratings

Configure filtros de contenido para los anuncios cargados por la aplicación.

=== "GDScript"
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_UNSPECIFIED`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_G`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_PG`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_T`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_MA`

=== "C#"
    - `RequestConfiguration.MaxAdContentRatingUnspecified`
    - `RequestConfiguration.MaxAdContentRatingG`
    - `RequestConfiguration.MaxAdContentRatingPG`
    - `RequestConfiguration.MaxAdContentRatingT`
    - `RequestConfiguration.MaxAdContentRatingMA`

---

## Propiedades

### `max_ad_content_rating` / `MaxAdContentRating`

La clasificación máxima de contenido del anuncio permitida para los anuncios servidos a la aplicación.

=== "GDScript"
    ```gdscript
    var max_ad_content_rating: String
    ```

=== "C#"
    ```csharp
    public string MaxAdContentRating { get; set; }
    ```

### `tag_for_child_directed_treatment` / `ChildDirectedTreatment`

Configura el ajuste de tratamiento dirigido a niños para el cumplimiento de COPPA.

=== "GDScript"
    ```gdscript
    var tag_for_child_directed_treatment: int # Matches values from TagForChildDirectedTreatment enum
    ```

=== "C#"
    ```csharp
    public TagForChildDirectedTreatment ChildDirectedTreatment { get; set; }
    ```

### `tag_for_under_age_of_consent` / `UnderAgeOfConsent`

Configura el ajuste de menoría de edad para el cumplimiento del GDPR.

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: int # Matches values from TagForUnderAgeOfConsent enum
    ```

=== "C#"
    ```csharp
    public TagForUnderAgeOfConsent UnderAgeOfConsent { get; set; }
    ```

### `test_device_ids` / `TestDeviceIds`

Una lista de IDs de dispositivos de prueba para recibir anuncios de prueba.

=== "GDScript"
    ```gdscript
    var test_device_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceIds { get; set; }
    ```
