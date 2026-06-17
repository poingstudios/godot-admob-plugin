# Integrar BidMachine con la mediación

Esta guía explica cómo utilizar el SDK de anuncios de Google para móviles para cargar y presentar anuncios desde BidMachine a través de[mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar BidMachine en la configuración de mediación de una aplicación Godot e integrar el SDK y el adaptador de BidMachine en su aplicación Godot.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/mediation/bidmachine)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/mediation/bidmachine)

## Integraciones y formatos de anuncios admitidos

El adaptador de mediación de AdMob para BidMachine tiene las siguientes capacidades:

 | Integración |  | 
 | ------------- | --- | 
 | Ofertas | ✅ | 
 | Cascada | ✅ | 

 | Formatos |  | 
 | ----------------------- | ------------ | 
 | Bandera | ✅ | 
 | intersticial | ✅ | 
 | Recompensado | ✅ | 
 | Intersticial recompensado |  | 
 | Nativo |  | 

## Requisitos previos
- Completa el[Guía de introducción](../../index.md)
- Completa la mediación[Guía de introducción](../get_started.md)

## Paso 1: configurar BidMachine
Recomendamos seguir el tutorial para[Androide](https://developers.google.com/admob/android/mediation/bidmachine#step_1_set_up_bidmachine)o[iOS](https://developers.google.com/admob/ios/mediation/bidmachine#step_1_set_up_bidmachine), ya que será igual para ambos.

## Paso 2: Configure los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para[Androide](https://developers.google.com/admob/android/mediation/bidmachine#step_2)o[iOS](https://developers.google.com/admob/ios/mediation/bidmachine#step_2), ya que será igual para ambos.

## Paso 3: importe el complemento BidMachine SDK

=== "Androide"
    1. Descargue el complemento para[Androide](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. Dentro encontrará una carpeta `bidmachine`.
    3. Copie el contenido de la carpeta `bidmachine` y péguelo en la carpeta del complemento de Android en `res://addons/admob/android/bin/`.

=== "iOS"
El adaptador BidMachine **ya está incluido** en la descarga del complemento estándar de iOS. Si seguiste el[Guía de instalación de iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-bidmachine.gdip` y marcos relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: habilite el complemento

=== "Androide"
Asegúrese de habilitar **Bidmachine** en **Configuración del proyecto** (en `Admob > Android > Mediación > Bidmachine`).

=== "iOS"
Asegúrese de marcar `Ad Mob` y `Ad Mob Bid Machine` en la lista de complementos en sus **Preajustes de exportación de iOS** (además de ingresar el ID de su aplicación AdMob en la configuración de Plists).

## Paso 5: Pasos opcionales (Configuración regulatoria)

### Consentimiento de la UE y RGPD
Bajo Google[Política de consentimiento del usuario de la UE](https://www.google.com/about/company/consentstaging.html), debe realizar ciertas divulgaciones a los usuarios en el Espacio Económico Europeo (EEE) y obtener su consentimiento para el uso de cookies u otro almacenamiento local, y para el uso de datos personales.

Para pasar información de consentimiento del RGPD al SDK de BidMachine, utilice el siguiente código:

=== "GDScript"

    ```gdscript
    # Set whether user is subject to GDPR
    BidMachine.set_subject_to_gdpr(true)
    
    # Set the consent status
    BidMachine.set_consent_status(true)
    ```

=== "C#"

    ```csharp
    // Set whether user is subject to GDPR
    BidMachine.SetSubjectToGdpr(true);
    
    // Set the consent status
    BidMachine.SetConsentStatus(true);
    ```

### CCPA
Para cumplir con la CCPA, puede configurar la cadena de privacidad de EE. UU. El siguiente código de muestra muestra cómo pasar esta información al SDK de BidMachine:

=== "GDScript"

    ```gdscript
    BidMachine.set_us_privacy_string("1YNN")
    ```

=== "C#"

    ```csharp
    BidMachine.SetUsPrivacyString("1YNN");
    ```
