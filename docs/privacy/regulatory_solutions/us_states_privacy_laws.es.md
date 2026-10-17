# Divulgar a los usuarios de EE. UU.

!!! note
    **Importante:** Verifica que tienes el permiso de **Administración de cuentas** para completar la configuración de consentimiento de la UE y GDPR, regulaciones de los estados de EE. UU. y la User Messaging Platform. Consulta [Administrar el acceso de los usuarios a tu cuenta](https://support.google.com/admob/answer/2784628) para obtener más información.

Para ayudarte a cumplir con las [leyes de privacidad de los estados de EE. UU.](https://support.google.com/admob/answer/9561022), el SDK de Google Mobile Ads te permite usar el parámetro de [procesamiento de datos restringido (RDP)](https://business.safety.google/rdp/) de Google para indicar si se debe habilitar RDP. Google también admite la [Global Privacy Platform (GPP)](https://iabtechlab.com/standards/global-privacy-platform-gpp/) para los estados de EE. UU. aplicables.

Cuando el SDK de Google Mobile Ads utiliza cualquiera de las señales, el SDK restringe ciertos identificadores únicos y otros datos procesados en la prestación de servicios para ti.

Debes decidir cómo el procesamiento de datos restringido puede respaldar tus planes de cumplimiento y cuándo habilitarlo. Determina si debes usar el parámetro RDP directamente o señalar las opciones de consentimiento y privacidad con la especificación GPP.

Esta guía te ayuda a habilitar RDP globalmente mediante el almacenamiento local o por solicitud de anuncio, y a utilizar la señal GPP.

Este documento está basado en:

- [Documentación del SDK de Google Mobile Ads para Android](https://developers.google.com/admob/android/privacy/us-states)
- [Documentación del SDK de Google Mobile Ads para iOS](https://developers.google.com/admob/ios/privacy/us-states)

## Requisitos previos

- Completa la [Guía de introducción](../user_messaging_tools/get_started.md).
- Crea un [mensaje de regulaciones de los estados de EE. UU.](https://support.google.com/admob/answer/13467025).

## Etiquetar para usuarios menores de edad de consentimiento

Para indicar si un usuario está por debajo de la edad de consentimiento, establece `tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA). Cuando estableces TFUA en `true`, el SDK de UMP no solicita el consentimiento del usuario. Si tu aplicación tiene una audiencia mixta, establece este parámetro para usuarios menores para garantizar que no se solicite el consentimiento.

!!! warning "Importante"
    El SDK de UMP no reenvía la etiqueta TFUA establecida en las solicitudes de consentimiento al SDK de Mobile Ads. Debes establecer explícitamente `tag_for_under_age_of_consent` en las solicitudes de anuncios. Si no estableces `tag_for_under_age_of_consent` en las solicitudes de anuncios, el SDK de UMP no recopilará ninguna información que le permita a Google determinar si usuarios menores de la edad de consentimiento usan o no tu aplicación.

    Para obtener más información, consulta [Etiquetar una solicitud de anuncio para usuarios menores de edad de consentimiento](../../advanced_topics/targeting.md).

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
        // Indica que el usuario está por debajo de la edad de consentimiento.
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## Habilitar la señal de RDP

Google admite dos formas de habilitar el procesamiento de datos restringido (RDP). Ambas son válidas y compatibles con el SDK de Google Mobile Ads:

### Globalmente en el almacenamiento local (Recomendado)

En los SDKs oficiales de Android e iOS, Google recomienda escribir la clave `gad_rdp` directamente en el almacenamiento local (`SharedPreferences` en Android, `UserDefaults` en iOS). El SDK de Google Mobile Ads lee esta clave automáticamente durante la carga de anuncios y aplica el RDP a todas las solicitudes de anuncios de la aplicación:

=== "GDScript"

    ```gdscript
    if OS.get_name() == "Android":
        ApplicationPreferences.set_int("gad_rdp", 1)
    elif OS.get_name() == "iOS":
        ApplicationPreferences.set_bool("gad_rdp", true)
    ```

=== "C#"

    ```csharp
    if (OperatingSystem.IsAndroid())
    {
        ApplicationPreferences.SetInt("gad_rdp", 1);
    }
    else if (OperatingSystem.IsIOS())
    {
        ApplicationPreferences.SetBool("gad_rdp", true);
    }
    ```

### Por solicitud de anuncio

También puedes habilitar la señal de RDP por solicitud de anuncio insertando la clave `rdp` con un valor de `1` (o `"1"` en C#) en el diccionario `extras` de un [`AdRequest`](../../reference/classes/AdRequest.md):

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["rdp"] = 1
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("rdp", "1");
    ```

!!! note
    **Consejo:** Puedes usar el rastreo de red o una herramienta de proxy como [Charles](https://www.charlesproxy.com/) para capturar el tráfico HTTPS de tu aplicación e inspeccionar las solicitudes de anuncios en busca de un parámetro **&rdp=**.

## Usar la señal IAB GPP

Si recopilas decisiones de consentimiento con una plataforma de administración de consentimiento (CMP) o tus propios mensajes personalizados, el SDK de Google Mobile Ads respeta las señales GPP escritas en el almacenamiento local. El SDK de la User Messaging Platform (UMP) admite la escritura de la señal GPP. Para recopilar el consentimiento de los estados de EE. UU., configura un mensaje de **Regulaciones de los estados de EE. UU.** en tu cuenta de AdMob en **Privacidad y mensajería**. Para la configuración de UMP, consulta [Configurar el SDK de UMP](../user_messaging_tools/get_started.md).

### Leer las opciones de consentimiento

El SDK de UMP escribe los datos de GPP en el almacenamiento local según la [especificación IAB GPP](https://iabtechlab.com/standards/global-privacy-platform-gpp/). Ten en cuenta que el SDK de UMP solo completa estas dos claves para gestionar las regulaciones de los estados de EE. UU.:

- `IABGPP_HDR_GppString`: La cadena GPP que contiene el consentimiento del usuario codificado y las preferencias de exclusión (opt-out).
- `IABGPP_GppSID`: Los IDs de sección incluidos en la cadena GPP (por ejemplo, `7` para US National).

Puedes leer las opciones de consentimiento del almacenamiento local utilizando [`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md):

=== "GDScript"

    ```gdscript
    var gpp_string := ApplicationPreferences.get_string("IABGPP_HDR_GppString")
    var gpp_sid := ApplicationPreferences.get_string("IABGPP_GppSID")
    ```

=== "C#"

    ```csharp
    var gppString = ApplicationPreferences.GetString("IABGPP_HDR_GppString");
    var gppSid = ApplicationPreferences.GetString("IABGPP_GppSID");
    ```

## Probar tus mensajes de regulaciones de los estados de EE. UU.

Para probar el flujo de mensajes de regulaciones de los estados de EE. UU. usando el SDK de UMP en un dispositivo de prueba, fuerza la geografía de depuración en [`ConsentDebugSettings`](../../reference/classes/ConsentDebugSettings.md):

- **Simular un estado regulado de EE. UU.:** Establece `debug_geography` en `DebugGeography.Values.REGULATED_US_STATE` (o `DebugGeography.RegulatedUsState` en C#).
- **Suprimir mensajes de regulaciones de los estados de EE. UU.:** Establece `debug_geography` en `DebugGeography.Values.OTHER` (o `DebugGeography.Other` en C#).

=== "GDScript"

    ```gdscript
    var request := ConsentRequestParameters.new()
    var debug_settings := ConsentDebugSettings.new()
    debug_settings.debug_geography = DebugGeography.Values.REGULATED_US_STATE
    debug_settings.test_device_hashed_ids.append("TEST-DEVICE-HASHED-ID")
    request.consent_debug_settings = debug_settings

    UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;

    var request = new ConsentRequestParameters();
    var debugSettings = new ConsentDebugSettings();
    debugSettings.DebugGeography = DebugGeography.RegulatedUsState;
    debugSettings.TestDeviceHashedIds.Add("TEST-DEVICE-HASHED-ID");
    request.ConsentDebugSettings = debugSettings;

    UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdated);
    ```

## Mediación

Si utilizas la [mediación](../../mediate/get_started.md), ve a **Privacidad y mensajería** > **Regulaciones de los estados de EE. UU.** en la interfaz de AdMob para administrar los socios de anuncios para los estados de EE. UU. Consulta la documentación de cada socio de red publicitaria para determinar las opciones que ofrecen para el cumplimiento de las regulaciones de los estados de EE. UU.
