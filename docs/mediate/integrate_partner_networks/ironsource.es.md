# Integrar IronSource con la mediación

Esta guía explica cómo utilizar el SDK de anuncios móviles de Google para cargar y presentar anuncios desde IronSource a través de[mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar IronSource en la configuración de mediación de una aplicación Godot e integrar el SDK y el adaptador de IronSource en su aplicación Godot.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/mediation/ironsource)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/mediation/ironsource)

## Integraciones y formatos de anuncios admitidos

El adaptador de mediación de AdMob para IronSource tiene las siguientes capacidades:

 | Integración |  | 
 | ------------- | --- | 
 | Ofertas | ✅ | 
 | Cascada | ✅ | 

 | Formatos |  | 
 | ----------------------- | ------------ | 
 | Bandera | ✅ | 
 | intersticial | ✅ | 
 | Recompensado | ✅ | 
 | Intersticial recompensado | ✅[^1] | 
 | Nativo |  | 

[^1]: Este formato solo se admite en la integración en cascada.

## Requisitos previos
- Completa el[Guía de introducción](../../index.md)
- Completa la mediación[Guía de introducción](../get_started.md)

## Paso 1: configurar IronSource
Recomendamos seguir el tutorial para[Androide](https://developers.google.com/admob/android/mediation/ironsource#step_1_set_up_ironsource)o[iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_1_set_up_ironsource), ya que será igual para ambos.

## Paso 2: Configure los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para[Androide](https://developers.google.com/admob/android/mediation/ironsource#step_2)o[iOS](https://developers.google.com/admob/ios/mediation/ironsource#step_2), ya que será igual para ambos.

## Paso 3: Importe el complemento SDK de IronSource

=== "Androide"
    1. Descargue el complemento para[Androide](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. Dentro, encontrará una carpeta `ironsource`.
    3. Copie el contenido de la carpeta `ironsource` y péguelo en la carpeta del complemento de Android en `res://addons/admob/android/bin/`.

=== "iOS"
El adaptador IronSource **ya está incluido** en la descarga del complemento estándar de iOS. Si seguiste el[Guía de instalación de iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-ironsource.gdip` y marcos relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: habilite el complemento

=== "Androide"
Asegúrese de habilitar **IronSource** en **Configuración del proyecto** (en `Admob > Android > Mediación > Ironsource`).

=== "iOS"
Asegúrese de marcar `Ad Mob` y `Ad Mob Iron Source` en la lista de complementos en sus **Preajustes de exportación de iOS** (además de ingresar el ID de su aplicación AdMob en la configuración de Plists).

## Paso 5: Pasos opcionales (Configuración regulatoria)

### Consentimiento de la UE y RGPD
Bajo Google[Política de consentimiento del usuario de la UE](https://www.google.com/about/company/consentstaging.html), debe realizar ciertas divulgaciones a los usuarios en el Espacio Económico Europeo (EEE) y obtener su consentimiento para el uso de cookies u otro almacenamiento local, y para el uso de datos personales.

Para pasar información de consentimiento del RGPD al SDK de IronSource, utilice el siguiente código:

=== "GDScript"

    ```gdscript
    IronSource.set_consent(true)
    ```

=== "C#"

    ```csharp
    IronSource.SetConsent(true);
    ```

### CCPA
Para cumplir con la CCPA, puede establecer la configuración de metadatos. El siguiente código de muestra muestra cómo pasar esta información al SDK de IronSource:

=== "GDScript"

    ```gdscript
    IronSource.set_metadata("do_not_sell", "false")
    ```

=== "C#"

    ```csharp
    IronSource.SetMetaData("do_not_sell", "false");
    ```

### ID de usuario
Para configurar el ID de usuario de IronSource para integraciones de anuncios recompensados, utilice el siguiente código:

=== "GDScript"

    ```gdscript
    IronSource.set_user_id("unique_user_id_123")
    ```

=== "C#"

    ```csharp
    IronSource.SetUserId("unique_user_id_123");
    ```
