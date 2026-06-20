# Integrar i-mobile con Mediación

Esta guía explica cómo utilizar el SDK de Google Mobile Ads para cargar y presentar anuncios de i-mobile a través de [mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar i-mobile en la configuración de mediación de una aplicación de Godot y cómo integrar el SDK y el adaptador de i-mobile.

Este documento está basado en:

- [Documentación del SDK de Google Mobile Ads para Android (Inglés)](https://developers.google.com/admob/android/mediation/imobile)
- [Documentación del SDK de Google Mobile Ads para iOS (Inglés)](https://developers.google.com/admob/ios/mediation/imobile)

## Integraciones y formatos de anuncios compatibles

El adaptador de mediación de AdMob para i-mobile tiene las siguientes capacidades:

| Integración |   |
|-------------|---|
| Bidding     |   |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Bonificado (Rewarded) |            |
| Intersticial Bonificado|            |
| Nativo                |            |

## Requisitos previos
- Complete la [Guía de inicio](../../index.md)
- Complete la [Guía de inicio de mediación](../get_started.md)

## Paso 1: Configurar i-mobile
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/imobile#step_1_set_up_i-mobile) o [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_1_set_up_i-mobile), ya que será el mismo para ambos.

## Paso 2: Configurar los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/imobile#step_2) o [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_2), ya que será el mismo para ambos.

## Paso 3: Importar el plugin del SDK de i-mobile

=== "Android"
    1. Descargue el plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. Adentro, encontrará una carpeta `imobile`.
    3. Copie el contenido de la carpeta `imobile` y péguelo en la carpeta de plugins de Android en `res://addons/admob/android/bin/`.

=== "iOS"
    El adaptador de i-mobile **ya está incluido** en la descarga estándar del plugin para iOS. Si siguió la [Guía de instalación para iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-imobile.gdip` y frameworks relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: Habilitar el plugin

=== "Android"
    Asegúrese de habilitar **Imobile** en la **Configuración del Proyecto** (bajo `Admob > Android > Mediation > Imobile`).

=== "iOS"
    Asegúrese de marcar tanto `Ad Mob` como `Ad Mob iMobile` en la lista de Plugins en sus **iOS Export Presets** (así como ingresar su AdMob App ID en la configuración de Plists).

## Paso 5: Pasos opcionales (Configuración regulatoria)
i-mobile no requiere ninguna configuración de código personalizada adicional para la configuración de GDPR o CCPA a través de la API del adaptador de Google Mobile Ads. Los ajustes de consentimiento y privacidad se gestionan mediante la configuración estándar del panel de AdMob o las opciones a nivel de plataforma.
