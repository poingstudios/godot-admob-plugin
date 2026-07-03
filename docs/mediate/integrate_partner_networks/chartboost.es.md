# Integrar Chartboost con mediación

Esta guía explica cómo utilizar el SDK de Google Mobile Ads para cargar y presentar anuncios de Chartboost a través de la [mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar Chartboost en la configuración de mediación de una aplicación de Godot e integrar el SDK y el adaptador de Chartboost en su aplicación de Godot.

Este documento se basa en:

- [Documentación del SDK de Google Mobile Ads para Android (Inglés)](https://developers.google.com/admob/android/mediation/chartboost)
- [Documentación del SDK de Google Mobile Ads para iOS (Inglés)](https://developers.google.com/admob/ios/mediation/chartboost)

## Integraciones y formatos de anuncios compatibles

El adaptador de mediación de AdMob para Chartboost tiene las siguientes capacidades:

| Integración |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Recompensado          | ✅          |
| Intersticial Recompensado |            |
| Nativo                |            |

## Requisitos previos
- Completa la [Guía de introducción](../../index.md)
- Completa la [Guía de introducción a la mediación](../get_started.md)

## Paso 1: Configurar Chartboost
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/chartboost#step_1_set_up_chartboost) o [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_1_set_up_chartboost), ya que será el mismo para ambos.

## Paso 2: Configurar los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/chartboost#step_2) o [iOS](https://developers.google.com/admob/ios/mediation/chartboost#step_2), ya que será el mismo para ambos.

## Paso 3: Importar el complemento del SDK de Chartboost

=== "Android"
    1. Descargue el complemento para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. En su interior, encontrará una carpeta `chartboost`.
    3. Copie el contenido de la carpeta `chartboost` y péguelo en la carpeta de complementos de Android en `res://addons/admob/android/bin/`.

=== "iOS"
    El adaptador de Chartboost **ya está incluido** en la descarga estándar del complemento para iOS. Si siguió la [Guía de instalación de iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-chartboost.gdip` y marcos relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: Habilite el complemento

=== "Android"
    Asegúrese de habilitar **Chartboost** en **Configuración del proyecto** (bajo `Admob > Android > Mediación > Chartboost`).

=== "iOS"
    Asegúrese de marcar tanto `Ad Mob` como `Ad Mob Chartboost` en la lista de Plugins en sus **Preajustes de exportación de iOS** (además de ingresar su ID de aplicación de AdMob en la configuración de Plists).

## Paso 5: Pasos opcionales (Ajustes regulatorios)

### Consentimiento de la UE y GDPR
Bajo la [Política de consentimiento de usuarios de la UE](https://www.google.com/about/company/consentstaging.html) de Google, debe realizar ciertas declaraciones a los usuarios en el Espacio Económico Europeo (EEE) y obtener su consentimiento para el uso de cookies u otro almacenamiento local, y para el uso de datos personales.

Para pasar información de consentimiento de GDPR al SDK de Chartboost, utilice el siguiente código:

=== "GDScript"

    ```gdscript
    Chartboost.set_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetConsent(true);
    ```

### CCPA
Para cumplir con la CCPA, puede establecer los ajustes de "no vender" (do not sell). El siguiente código de ejemplo muestra cómo pasar esta información al SDK de Chartboost:

=== "GDScript"

    ```gdscript
    Chartboost.set_ccpa_consent(true)
    ```

=== "C#"

    ```csharp
    Chartboost.SetCCPAConsent(true);
    ```
