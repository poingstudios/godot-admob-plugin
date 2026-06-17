# Orientación
Esta guía explica cómo proporcionar información de orientación a una solicitud de anuncio.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/targeting)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/targeting)

## Requisitos previos
- Completa el[Guía de introducción](../index.md)


## Solicitar configuración

"RequestConfiguration" es una entidad utilizada para recopilar detalles de orientación que se pueden aplicar globalmente a través de un método estático dentro de "MobileAds". Y se aplica mediante `MobileAds.set_request_configuration(request_configuration)`

### Entorno dirigido a niños {: #child-directed-setting }
para cumplir con[Ley de protección de la privacidad infantil en línea (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy), puede configurar la opción "etiqueta para tratamiento dirigido a niños". Esto significa que desea que su contenido sea tratado como dirigido a niños a efectos de la COPPA. Es importante asegurarse de tener la autoridad para tomar esta decisión en nombre del propietario de la aplicación. Tenga en cuenta que el uso indebido de esta configuración puede provocar la cancelación de su cuenta de Google.

Como desarrollador de aplicaciones, puedes indicar si tu contenido está dirigido a niños al realizar solicitudes de anuncios. Cuando especifica que su contenido está dirigido a niños, Google tomará medidas para desactivar la publicidad basada en intereses (IBA) y los anuncios de remarketing para esa solicitud de anuncio en particular.

Para implementar esta configuración, puede usar `RequestConfiguration.new().tag_for_child_directed_treatment = int` con las siguientes opciones:

- Utilice `tag_for_child_directed_treatment` con `RequestConfiguration.TagForChildDirectedTreatment.TRUE` para indicar que su contenido debe tratarse como dirigido a niños para cumplir con COPPA. Esto evitará la transmisión del identificador de publicidad de Android (AAID). Esto evitará la transmisión del Identificador de Publicidad, IDFA.

- Utilice `tag_for_child_directed_treatment` con `RequestConfiguration.TagForChildDirectedTreatment.FALSE` para especificar que su contenido no debe tratarse como dirigido a niños para fines COPPA.

- Utilice `tag_for_child_directed_treatment` con `RequestConfiguration.TagForChildDirectedTreatment.UNSPECIFIED` si no desea especificar cómo se debe tratar su contenido en las solicitudes de anuncios con respecto a COPPA.

El siguiente ejemplo indica que desea que su contenido sea tratado como dirigido a niños a efectos de COPPA:

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.ChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatment.True;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

### Usuarios menores de edad de consentimiento

Puede configurar sus solicitudes de anuncios para recibir tratamiento para los usuarios del Espacio Económico Europeo (EEE) que tienen menos de la edad de consentimiento. Esta característica está diseñada para ayudar con el cumplimiento de la[Reglamento General de Protección de Datos (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679). Es importante tener en cuenta que el RGPD puede imponer obligaciones legales adicionales, por lo que es recomendable consultar con un asesor legal y revisar las directrices de la Unión Europea. Las herramientas de Google están destinadas a respaldar el cumplimiento, pero no reemplazan las responsabilidades legales de los editores.[Obtenga más información sobre cómo el RGPD afecta a los editores](https://support.google.com/admob/answer/7666366).

Al utilizar esta función, una solicitud de anuncio contendrá un parámetro "Etiqueta para usuarios menores de la edad de consentimiento en Europa" (TFUA). Este parámetro desactiva la publicidad personalizada, incluido el remarketing, para todas las solicitudes de anuncios. También evita solicitudes a proveedores de publicidad de terceros, como píxeles de medición de publicidad y servidores de publicidad de terceros.

De manera similar a la configuración dirigida a niños, puede utilizar la propiedad en la clase `RequestConfiguration.new()` para establecer el parámetro TFUA: `tag_for_under_age_of_consent = int`. Ofrece las siguientes opciones:

- Utilice `tag_for_under_age_of_consent` con `RequestConfiguration.TagForUnderAgeOfConsent.TRUE` para indicar que desea que la solicitud de anuncio reciba tratamiento para usuarios en el Espacio Económico Europeo (EEE) menores de la edad de consentimiento. Esto también evitará la transmisión del identificador de publicidad de Android (AAID). Esto también impedirá la transmisión del Identificador de Publicidad, IDFA.

- Utilice `tag_for_under_age_of_consent` con `RequestConfiguration.TagForUnderAgeOfConsent.FALSE` para especificar que no desea que la solicitud de anuncio reciba tratamiento para usuarios en el Espacio Económico Europeo (EEE) menores de la edad de consentimiento.

- Utilice `tag_for_under_age_of_consent` con `RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED` para indicar que no ha especificado si la solicitud de anuncio debe recibir tratamiento para usuarios en el Espacio Económico Europeo (EEE) menores de edad de consentimiento.

A continuación se muestra un ejemplo que indica su intención de incluir TFUA en sus solicitudes de anuncios:

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.UnderAgeOfConsent = RequestConfiguration.TagForUnderAgeOfConsent.Unspecified;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

Las etiquetas para habilitar el[Entorno dirigido a niños](#child-directed-setting)y la propiedad `tag_for_under_age_of_consent` no deben establecerse simultáneamente en `true`. Si es así, el entorno dirigido a niños tiene prioridad.


### Filtrado de contenido publicitario

Para garantizar el cumplimiento de las normas de Google Play[Política de anuncios inapropiados](https://support.google.com/googleplay/android-developer/answer/9857753#zippy=%2Cexamples-of-common-violations), que abarca ofertas asociadas dentro de los anuncios, es esencial que todos los anuncios y sus ofertas asociadas que se muestran en su aplicación estén alineados con la[calificación de contenido](https://support.google.com/googleplay/android-developer/answer/9898843). Esto se aplica incluso si el contenido en sí cumple con las políticas de Google Play.

Herramientas como la clasificación máxima del contenido de los anuncios le brindan un mayor control sobre el contenido de los anuncios que se muestran a sus usuarios. Puede establecer una clasificación de contenido máxima para garantizar el cumplimiento de las políticas de la plataforma.

Las aplicaciones pueden especificar una clasificación máxima de contenido publicitario para sus solicitudes de anuncios mediante la propiedad `max_ad_content_rating`. Los anuncios de AdMob devueltos con esta configuración tendrán una clasificación de contenido que coincida o quede por debajo del nivel especificado. Los valores disponibles para este extra de red se basan en[clasificaciones de etiquetas de contenido digital](https://support.google.com/admob/answer/7562142)y debe ser una de las siguientes cadenas:

- `Solicitud de configuración.MAX_AD_CONTENT_RATING_G`
- `Solicitud de configuración.MAX_AD_CONTENT_RATING_PG`
- `Solicitud de configuración.MAX_AD_CONTENT_RATING_T`
- `Solicitud de configuración.MAX_AD_CONTENT_RATING_MA`

El siguiente código demuestra cómo configurar un objeto "RequestConfiguration" para especificar que el contenido del anuncio devuelto no debe exceder la designación de etiqueta de contenido digital "G":

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.MaxAdContentRating = RequestConfiguration.MaxAdContentRatingG;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

Más información sobre:

- [Establecer la clasificación máxima de contenido para cada solicitud de anuncio](https://support.google.com/admob/answer/10477886)
- [Establecer la clasificación máxima del contenido publicitario para una aplicación o cuenta](https://support.google.com/admob/answer/7562142)

