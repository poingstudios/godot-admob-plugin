# RequestConfiguration

A classe `RequestConfiguration` agrega configurações globais de solicitação de anúncio aplicadas a cada carregamento de anúncio.

## Constantes

### Device ID Emulator

Use esta constante para ativar anúncios de teste em emuladores.

=== "GDScript"
    ```gdscript
    RequestConfiguration.DEVICE_ID_EMULATOR
    ```

=== "C#"
    ```csharp
    RequestConfiguration.DeviceIdEmulator
    ```

### Max Ad Content Ratings

Configure filtros de conteúdo para anúncios carregados pelo aplicativo.

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

## Propriedades

### `max_ad_content_rating` / `MaxAdContentRating`

A classificação máxima de conteúdo do anúncio permitida para anúncios veiculados ao aplicativo.

=== "GDScript"
    ```gdscript
    var max_ad_content_rating: String
    ```

=== "C#"
    ```csharp
    public string MaxAdContentRating { get; set; }
    ```

### `tag_for_child_directed_treatment` / `ChildDirectedTreatment`

Configura a configuração de tratamento direcionado a crianças para conformidade com a COPPA.

=== "GDScript"
    ```gdscript
    var tag_for_child_directed_treatment: int # Matches values from TagForChildDirectedTreatment enum
    ```

=== "C#"
    ```csharp
    public TagForChildDirectedTreatment ChildDirectedTreatment { get; set; }
    ```

### `tag_for_under_age_of_consent` / `UnderAgeOfConsent`

Configura a configuração de menoridade para conformidade com o GDPR.

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: int # Matches values from TagForUnderAgeOfConsent enum
    ```

=== "C#"
    ```csharp
    public TagForUnderAgeOfConsent UnderAgeOfConsent { get; set; }
    ```

### `test_device_ids` / `TestDeviceIds`

Uma lista de IDs de dispositivos de teste para receber anúncios de teste.

=== "GDScript"
    ```gdscript
    var test_device_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceIds { get; set; }
    ```
