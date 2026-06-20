# Integrar InMobi con Mediación

Esta guía explica cómo utilizar el SDK de Google Mobile Ads para cargar y presentar anuncios de InMobi a través de [mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar InMobi en la configuración de mediación de una aplicación de Godot y cómo integrar el SDK y el adaptador de InMobi.

Este documento está basado en:

- [Documentación del SDK de Google Mobile Ads para Android (Inglés)](https://developers.google.com/admob/android/mediation/inmobi)
- [Documentación del SDK de Google Mobile Ads para iOS (Inglés)](https://developers.google.com/admob/ios/mediation/inmobi)

## Integraciones y formatos de anuncios compatibles

El adaptador de mediación de AdMob para InMobi tiene las siguientes capacidades:

| Integración |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos               |            |
|-----------------------|------------|
| Banner                | ✅          |
| Intersticial          | ✅          |
| Bonificado (Rewarded) | ✅          |
| Intersticial Bonificado|            |
| Nativo                | ✅          |

## Requisitos previos
- Complete la [Guía de inicio](../../index.md)
- Complete la [Guía de inicio de mediación](../get_started.md)

## Paso 1: Configurar InMobi
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/inmobi#step_1_set_up_inmobi) o [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_1_set_up_inmobi), ya que será el mismo para ambos.

## Paso 2: Configurar los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/inmobi#step_2) o [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_2), ya que será el mismo para ambos.

## Paso 3: Importar el plugin del SDK de InMobi

=== "Android"
    1. Descargue el plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. Adentro, encontrará una carpeta `inmobi`.
    3. Copie el contenido de la carpeta `inmobi` y péguelo en la carpeta de plugins de Android en `res://addons/admob/android/bin/`.

=== "iOS"
    El adaptador de InMobi **ya está incluido** en la descarga estándar del plugin para iOS. Si siguió la [Guía de instalación para iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-inmobi.gdip` y frameworks relacionados) en su directorio `res://ios/plugins/`.

## Paso 4: Habilitar el plugin

=== "Android"
    Asegúrese de habilitar **Inmobi** en la **Configuración del Proyecto** (bajo `Admob > Android > Mediation > Inmobi`).

=== "iOS"
    Asegúrese de marcar tanto `Ad Mob` como `Ad Mob InMobi` en la lista de Plugins en sus **iOS Export Presets** (así como ingresar su AdMob App ID en la configuración de Plists).

## Paso 5: Pasos opcionales (Configuración regulatoria)
InMobi no requiere ninguna configuración de código personalizada adicional para la configuración de GDPR o CCPA a través de la API del adaptador de Google Mobile Ads. Los ajustes de consentimiento y privacidad se gestionan automáticamente mediante el uso de una CMP certificada por Google (como el SDK de UMP) y la adición de InMobi como socio de anuncios personalizado en la configuración del panel de control de AdMob/Ad Manager.
