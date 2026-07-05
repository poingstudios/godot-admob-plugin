# Integrar Unity Ads con mediación

Esta guía explica cómo utilizar el SDK de Google Mobile Ads para cargar y presentar anuncios de Unity Ads a través de la [mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar Unity Ads en la configuración de mediación de una aplicación de Godot e integrar el SDK y el adaptador de Unity Ads en su aplicación de Godot.

Este documento se basa en:

- [Documentación del SDK de Google Mobile Ads para Android (Inglés)](https://developers.google.com/admob/android/mediation/unity)
- [Documentación del SDK de Google Mobile Ads para iOS (Inglés)](https://developers.google.com/admob/ios/mediation/unity)

## Integraciones y formatos de anuncios compatibles

El adaptador de mediación de AdMob para Unity Ads tiene las siguientes capacidades:

| Integración |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Recompensado          | ✅          |
| Intersticial Recompensado | ✅          |

## Requisitos previos
- Completa la [Guía de introducción](../../index.md)
- Completa la [Guía de introducción a la mediación](../get_started.md)

## Paso 1: Configurar Unity Ads
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/unity#step_1_set_up_unity_ads) o [iOS](https://developers.google.com/admob/ios/mediation/unity#step_1_set_up_unity_ads), ya que será el mismo para ambos.

## Paso 2: Configurar los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/unity#step_2) o [iOS](https://developers.google.com/admob/ios/mediation/unity#step_2), ya que será el mismo para ambos.

## Paso 3: Importar el complemento del SDK de Unity Ads

=== "Android"
    1. Descargue el complemento para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. En su interior, encontrará una carpeta `unity_ads`.
    3. Copie el contenido de la carpeta `unity_ads` y péguelo en la carpeta de complementos de Android en `res://addons/admob/android/bin/`.

=== "iOS"
    El adaptador de Unity Ads **ya está incluido** en la descarga estándar del complemento para iOS. Si siguió la [Guía de instalación de iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-unity_ads.gdip` y marcos relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: Habilite el complemento

=== "Android"
    Asegúrese de habilitar **Unity Ads** en **Configuración del proyecto** (bajo `Admob > Android > Mediación > Unity Ads`).

=== "iOS"
    Asegúrese de marcar tanto `Ad Mob` como `Ad Mob Unity Ads` en la lista de Plugins en sus **Preajustes de exportación de iOS** (además de ingresar su ID de aplicación de AdMob en la configuración de Plists).

## Paso 5: Pasos opcionales

### Política de consentimiento de usuarios de la UE
Para pasar información de consentimiento al SDK de Unity Ads, utilice el siguiente código:

=== "GDScript"

    ```gdscript
    UnityAds.set_consent(true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetConsent(true);
    ```

### Consentimiento de privacidad
Para configurar el consentimiento de privacidad (por ejemplo, para CCPA), utilice el siguiente código:

=== "GDScript"

    ```gdscript
    UnityAds.set_privacy_consent("user_privacy_data", true)
    ```

=== "C#"

    ```csharp
    UnityAds.SetPrivacyConsent("user_privacy_data", true);
    ```
