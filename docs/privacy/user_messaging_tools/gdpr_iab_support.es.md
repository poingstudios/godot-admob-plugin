# Divulgar a los usuarios del EEE

Según la [Política de consentimiento de usuarios de la UE](https://www.google.com/about/company/user-consent-policy/) de Google, debes realizar ciertas divulgaciones a tus usuarios en el Espacio Económico Europeo (EEE), el Reino Unido y Suiza, y obtener su consentimiento para usar cookies u otro almacenamiento local, donde sea legalmente requerido, y usar datos personales (como AdID) para publicar anuncios. Esta política refleja los requisitos de la Directiva sobre privacidad y comunicaciones electrónicas de la UE y el Reglamento general de protección de datos (GDPR).

Esta guía describe los pasos necesarios para admitir el mensaje GDPR IAB TCF v2 como parte del SDK de UMP. Se debe combinar con la guía de [Primeros pasos](get_started.md), que proporciona una descripción general de cómo poner en marcha tu aplicación con el SDK de UMP y los conceptos básicos para configurar tu mensaje. Las siguientes pautas son específicas para el mensaje GDPR IAB TCF v2. Para obtener más información, consulta [Cómo afectan los requisitos de IAB a los mensajes de consentimiento de la UE](https://support.google.com/admob/answer/10207733).

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/privacy/gdpr)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/privacy/gdpr)

## Requisitos previos

- Completa la [Guía de introducción](get_started.md).
- Crea un [mensaje sobre las regulaciones europeas para aplicaciones](https://support.google.com/admob/answer/10113207).

## Revocación del consentimiento

El GDPR requiere la [revocación del consentimiento](https://support.google.com/admob/answer/10113915) para permitir a los usuarios retirar sus opciones de consentimiento en cualquier momento. Consulta [Opciones de privacidad](get_started.md) para implementar una forma de que los usuarios retiren sus opciones de consentimiento.

## Etiquetar para usuarios que no alcanzan la edad de consentimiento

Para indicar si un usuario no alcanza la edad de consentimiento, establece `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA). Cuando estableces TFUA en `true`, el SDK de UMP no solicita el consentimiento del usuario. Si tu aplicación tiene una audiencia mixta, establece este parámetro para usuarios menores a fin de garantizar que no se solicite el consentimiento.

!!! warning "Importante"
    El SDK de UMP no reenvía la etiqueta TFUA establecida en las solicitudes de consentimiento al SDK de Google Mobile Ads. Debes establecer explícitamente `tag_for_under_age_of_consent` en la configuración de solicitudes de anuncios. Si no estableces `tag_for_under_age_of_consent` en las solicitudes de anuncios, el SDK de UMP no recopila información que permita a Google determinar si usuarios que no alcanzan la edad de consentimiento usan tu aplicación.

    Para obtener más información, consulta [Etiquetar una solicitud de anuncio para usuarios menores de la edad de consentimiento](../../advanced_topics/targeting.md).

El siguiente ejemplo establece TFUA en `true` en una solicitud de consentimiento de UMP:

=== "GDScript"

    ```gdscript
    var params := ConsentRequestParameters.new()
    params.tag_for_under_age_of_consent = true

    UserMessagingPlatform.consent_information.update(params, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Core;

    var parameters = new ConsentRequestParameters
    {
        // Indicar que el usuario no alcanza la edad de consentimiento.
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## Configurar el consentimiento en la mediación de AdMob

Para configurar el consentimiento en la mediación de AdMob, completa los pasos de las siguientes secciones.

### Agregar socios publicitarios a los mensajes de GDPR

Sigue los pasos de [Agregar socios publicitarios a los mensajes de GDPR publicados](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) para agregar tus socios de mediación a la lista de socios publicitarios. Si no lo haces, es posible que los socios no puedan publicar anuncios en tu aplicación.

La siguiente tabla enumera el nombre del socio tecnológico publicitario para cada fuente de anuncios:

| Fuente de anuncios | Nombre del socio publicitario |
| --- | --- |
| AppLovin | AppLovin Corp. |
| BidMachine | BidMachine |
| BIGO Ads SDK | Empathy Technology Pte.Ltd. (BIGO Ads) |
| Chartboost | Chartboost |
| DT Exchange | DT Exchange (Fyber Monetization) |
| i-mobile | i-mobile |
| InMobi | InMobi |
| ironSource Ads | ironSource Mobile |
| Liftoff Monetize | Liftoff |
| LY Ads Network | LY Ads Network |
| maio | maio |
| Meta Audience Network | Meta |
| Mintegral | Mobvista/Mintegral |
| Moloco Ads SDK | Moloco Ads |
| myTarget | Mail.ru |
| Pangle | Pangle DSP |
| PubMatic OpenWrap SDK | PubMatic |
| Unity Ads | Unity Ads |
| Verve HyBid SDK | Verve Group |

### Reenviar el consentimiento a las fuentes de anuncios

La siguiente tabla muestra qué fuentes de anuncios admiten el envío de señales de consentimiento de GDPR desde plataformas de gestión de consentimiento integradas con el Marco de Transparencia y Consentimiento (TCF) de IAB y la [especificación técnica de consentimiento adicional de Google](https://support.google.com/admob/answer/9681999) al SDK de las fuentes de anuncios:

| Fuente de anuncios | Versión mínima admitida |
| --- | --- |
| AppLovin | 7.0.0 |
| BidMachine | 1.0.0 |
| BIGO Ads SDK | 1.0.0 |
| Chartboost | 4.14.0 |
| DT Exchange | 3.3.0 |
| i-mobile | N/A¹ |
| InMobi | 4.6.4 |
| ironSource Ads | 2.6.0 |
| Liftoff Monetize | 5.2.2 |
| LY Ads Network | N/A¹ |
| maio | N/A¹ |
| Meta Audience Network | N/A² |
| Mintegral | 2.2.3 |
| Moloco Ads SDK | 1.0.0 |
| myTarget | 3.40.0 |
| Pangle | 5.9.0 |
| PubMatic OpenWrap SDK | 1.0.0 |
| Unity Ads | 3.20.0 |

¹ *La fuente de anuncios no atiende el tráfico del EEE.*  
² *Para obtener detalles, comunícate con tu administrador de socios de Meta.*

## Cómo leer las opciones de consentimiento

Una vez que se haya recopilado el consentimiento de GDPR, puedes leer las opciones de consentimiento desde el almacenamiento local siguiendo la [especificación TCF v2](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details).

La clave `IABTCF_PurposeConsents` indica el consentimiento para cada una de las [finalidades de TCF](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/#Appendix_A_Purposes_Features_and_Special_Purposes_Definitions). Puedes leer y escribir preferencias de la aplicación utilizando [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md).

El siguiente fragmento de código muestra cómo verificar el consentimiento para la Finalidad 1:

=== "GDScript"

    ```gdscript
    # Valor de ejemplo: "1111111111"
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents")

    # Las finalidades tienen un índice basado en cero. El índice 0 contiene información sobre la Finalidad 1.
    if not purpose_consents.is_empty():
        var purpose_one_string := purpose_consents[0]
        var has_consent_for_purpose_one := purpose_one_string == "1"
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;

    // Valor de ejemplo: "1111111111"
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents");

    // Las finalidades tienen un índice basado en cero. El índice 0 contiene información sobre la Finalidad 1.
    if (!string.IsNullOrEmpty(purposeConsents))
    {
        char purposeOneString = purposeConsents[0];
        bool hasConsentForPurposeOne = purposeOneString == '1';
    }
    ```

## Preguntas frecuentes

!!! note
    Consulta las [Preguntas frecuentes sobre los mensajes de las normativas europeas](https://support.google.com/admob/answer/13554116) para obtener más preguntas y respuestas.

**¿Qué sucede si no tomo medidas para cumplir con los requisitos de la plataforma de administración de consentimiento para publicar anuncios en el EEE, el Reino Unido y Suiza?**

A partir del 16 de enero de 2024, si un socio no adopta una [CMP certificada por Google](https://support.google.com/admob/answer/13554116), solo los [anuncios limitados](https://support.google.com/admob/answer/9882911) serán aptos para publicarse en el tráfico del EEE y del Reino Unido. Asegúrate de tener una CMP certificada implementada para no afectar la monetización.

**¿Cómo puedo verificar si el usuario dio su consentimiento?**

El consentimiento no se representa con un solo bit, sino con un conjunto de propósitos y proveedores según se define en la especificación de IAB TCF. Consulta [Políticas de consentimiento: anuncios personalizados y no personalizados](https://support.google.com/admanager/answer/9012903) para conocer los criterios de personalización de Google Ads.

Además, las ad techs en la lista de [proveedores de tecnología publicitaria](https://support.google.com/admob/answer/9012903) (ATP) de Google que no están registradas en la lista de proveedores de TCF utilizan la [especificación técnica de consentimiento adicional de Google](https://support.google.com/admob/answer/9681999) para la recopilación del consentimiento. Google publica la lista en [additional-consent-providers.csv](https://storage.googleapis.com/tcfac/additional-consent-providers.csv).

Para depurar una solicitud de anuncio individual, utiliza la función [Solucionar problemas de la configuración de privacidad](../../advanced_topics/ad_inspector/troubleshoot_privacy.md) en el inspector de anuncios para ver las siguientes señales de privacidad:

| Etiqueta del inspector de anuncios | Parámetro de consulta | Significado |
| --- | --- | --- |
| GDPR se aplica (`IABTCF_gdprApplies`) | `gdpr` | Si el GDPR se aplica a esta solicitud de anuncio. |
| Cadena TC (`IABTCF_TCString`) | `gdpr_consent` | La cadena TC. IAB proporciona una herramienta web para decodificar el valor. |
| Cadena AC (`IABTCF_AddtlConsent`) | `addtl_consent` | La cadena AC de la especificación técnica de consentimiento adicional de Google. |

Para leer las opciones de consentimiento mediante programación, consulta [Cómo leer las opciones de consentimiento](#como-leer-las-opciones-de-consentimiento).

**¿Debo usar el SDK de UMP de Google para cumplir con el requisito de CMP?**

No, puedes usar cualquier CMP de la [lista de CMPs certificadas por Google](https://support.google.com/admob/answer/13554116) para publicar anuncios.

**¿Cómo puedo volver a mostrar el formulario de consentimiento con el SDK de UMP incluso si el usuario ya dio su consentimiento?**

Si un usuario ya tomó una decisión de consentimiento, la solución de gestión de consentimiento de Google no solicitará recopilar un nuevo consentimiento hasta que la cadena TC expire o deje de ser válida.

El GDPR requiere la modificación del consentimiento para permitir a los usuarios retirar sus opciones en cualquier momento. Consulta las [opciones de privacidad](get_started.md) para implementar una forma de retirar las opciones. Para volver a mostrar el formulario, llama a `UserMessagingPlatform.show_privacy_options_form()` (`UserMessagingPlatform.ShowPrivacyOptionsForm()`).

**Integré una CMP certificada por Google, pero no veo ninguna solicitud de anuncio para socios de mediación, incluso de usuarios con consentimiento. ¿Por qué sucede esto?**

Según TCF, Google verifica que los proveedores de tecnología publicitaria y otras fuentes de demanda programática no infrinjan la política de Google y tengan al menos una base legal para procesar datos antes de incluirlos en la cascada de mediación. Consulta la sección [Configurar el consentimiento en la mediación de AdMob](#configurar-el-consentimiento-en-la-mediacion-de-admob) para obtener más información.

Al usar una CMP de terceros, confirma que admita almacenar la cadena AC e incluye a cada socio de mediación en la lista de proveedores de tecnología publicitaria que utiliza la CMP de terceros para recopilar el consentimiento.

**¿Puedo cambiar el funcionamiento de mi aplicación si los usuarios no dan su consentimiento? ¿Lo permiten las políticas?**

Los editores pueden leer la cadena de IAB TCF en sus aplicaciones. Consulta [Cómo leer las opciones de consentimiento](#como-leer-las-opciones-de-consentimiento) para leer las opciones mediante programación. Los editores deben revisar sus obligaciones legales con un asesor legal.

**Cuando selecciono "Administrar opciones" y doy mi consentimiento para todos los propósitos, no veo ningún anuncio. ¿Por qué sucede esto?**

Además de recopilar el consentimiento para los propósitos, también debes recopilar el consentimiento del proveedor. Ambos consentimientos son necesarios para que cualquier proveedor, como Google, publique anuncios apropiados.

**¿Cuál es la práctica recomendada para mostrar la alerta ATT de iOS y el consentimiento de GDPR al mismo usuario?**

Recomendamos mostrar el mensaje de consentimiento de GDPR primero y la alerta ATT de iOS en segundo lugar si el usuario dio su consentimiento para GDPR. Esto ya lo maneja el SDK de UMP si configuras ambos mensajes en la interfaz de AdMob. Consulta [Qué mensaje verán los usuarios](https://support.google.com/admob/answer/10115027) para más información.

Si no muestras la alerta ATT con el SDK de UMP, recomendamos [leer las opciones de consentimiento una vez recopilado el consentimiento de GDPR](#como-leer-las-opciones-de-consentimiento) para determinar si se debe mostrar la alerta ATT de iOS.

**¿Cómo implemento la versión 2 de la cadena AC para usuarios que ya dieron su consentimiento a la versión 1?**

Verifica la clave `IABTCF_AddtlConsent` en el almacenamiento local de acuerdo con la [especificación técnica de consentimiento adicional de Google](https://support.google.com/admob/answer/9681999) para determinar si un usuario dio su consentimiento para la versión 2 de la cadena AC y si necesitas volver a mostrar el formulario de consentimiento:

=== "GDScript"

    ```gdscript
    # Ejemplo de valor: "2~1.35.41.101~dv.9.21.81"
    var additional_consent := ApplicationPreferences.get_string("IABTCF_AddtlConsent")

    # El índice 0 contiene información sobre el número de versión de la especificación.
    if not additional_consent.is_empty():
        var spec_ac_version := additional_consent[0]
        var is_ac_version_2 := spec_ac_version == "2"
    ```

=== "C#"

    ```csharp
    // Ejemplo de valor: "2~1.35.41.101~dv.9.21.81"
    string additionalConsent = ApplicationPreferences.GetString("IABTCF_AddtlConsent");

    // El índice 0 contiene información sobre el número de versión de la especificación.
    if (!string.IsNullOrEmpty(additionalConsent))
    {
        char specACVersion = additionalConsent[0];
        bool isACVersion2 = specACVersion == '2';
    }
    ```
