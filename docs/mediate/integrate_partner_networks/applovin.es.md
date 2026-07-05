# Integrar AppLovin con la mediación

Esta guía explica cómo utilizar el SDK de anuncios móviles de Google para cargar y presentar anuncios desde AppLovin a través de[mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar AppLovin en la configuración de mediación de una aplicación Godot e integrar el SDK y el adaptador de AppLovin en su aplicación Godot.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/mediation/applovin)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/mediation/applovin)

## Integraciones y formatos de anuncios admitidos

El adaptador de mediación de AdMob para AppLovin tiene las siguientes capacidades:

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

## Paso 1: configura AppLovin
Recomendamos seguir el tutorial para[Androide](https://developers.google.com/admob/android/mediation/applovin#step_1_set_up_applovin)o[iOS](https://developers.google.com/admob/ios/mediation/applovin#step_1_set_up_applovin), ya que será igual para ambos.

## Paso 2: Configure los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para[Androide](https://developers.google.com/admob/android/mediation/applovin#step_2)o[iOS](https://developers.google.com/admob/ios/mediation/applovin#step_2), ya que será igual para ambos.

## Paso 3: importe el complemento SDK de AppLovin

=== "Androide"
    1. Descargue el complemento para[Androide](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. Dentro encontrarás una carpeta `applovin`.
    3. Copie el contenido de la carpeta `applovin` y péguelo en la carpeta del complemento de Android en `res://addons/admob/android/bin/`.

=== "iOS"
El adaptador AppLovin **ya está incluido** en la descarga del complemento estándar de iOS. Si seguiste el[Guía de instalación de iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-applovin.gdip` y marcos relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: habilite el complemento

=== "Androide"
Asegúrese de habilitar **Applovin** en **Configuración del proyecto** (en `Admob > Android > Mediación > Applovin`).

=== "iOS"
Asegúrese de marcar `Ad Mob` y `Ad Mob App Lovin` en la lista de complementos en sus **Preajustes de exportación de iOS** (además de ingresar el ID de su aplicación AdMob en la configuración de Plists).

## Paso 5: Pasos opcionales (Configuración regulatoria)

### Consentimiento de la UE y RGPD
Bajo Google[Política de consentimiento del usuario de la UE](https://www.google.com/about/company/consentstaging.html), debe realizar ciertas divulgaciones a los usuarios en el Espacio Económico Europeo (EEE) y obtener su consentimiento para el uso de cookies u otro almacenamiento local, y para el uso de datos personales.

Para pasar información de consentimiento GDPR al SDK de AppLovin, use el siguiente código:

=== "GDScript"

    ```gdscript
    AppLovin.set_has_user_consent(true)
    ```

=== "C#"

    ```csharp
    AppLovin.SetHasUserConsent(true);
    ```

### CCPA
Para cumplir con la CCPA, puede establecer la configuración de "no vender". El siguiente código de muestra muestra cómo pasar esta información al SDK de AppLovin:

=== "GDScript"

    ```gdscript
    AppLovin.set_do_not_sell(false)
    ```

=== "C#"

    ```csharp
    AppLovin.SetDoNotSell(false);
    ```

### Control de audio
Para silenciar/activar el audio de los anuncios de AppLovin, utilice el siguiente código:

=== "GDScript"

    ```gdscript
    AppLovin.set_muted(true)
    ```

=== "C#"

    ```csharp
    AppLovin.SetMuted(true);
    ```
