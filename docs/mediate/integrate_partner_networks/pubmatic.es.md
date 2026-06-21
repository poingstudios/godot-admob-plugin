# Integrar PubMatic OpenWrap con Mediación

Esta guía explica cómo utilizar el SDK de Google Mobile Ads para cargar y presentar anuncios de PubMatic a través de [mediación](../get_started.md). Proporciona instrucciones sobre cómo integrar PubMatic en la configuración de mediación de una aplicación de Godot e integrar el SDK y adaptador de PubMatic.

Este documento está basado en:

- [Documentación del SDK de Google Mobile Ads para Android](https://developers.google.com/admob/android/mediation/pubmatic)
- [Documentación del SDK de Google Mobile Ads para iOS](https://developers.google.com/admob/ios/mediation/pubmatic)

## Integraciones y formatos de anuncios soportados

El adaptador de mediación de AdMob para PubMatic tiene las siguientes capacidades:

| Integración |   |
|-------------|---|
| Bidding     | ✅ |
| Waterfall   | ✅ |

| Formatos              |            |
|-----------------------|------------|
| Banner                | ✅          |
| Interstitial          | ✅          |
| Rewarded              | ✅          |
| Rewarded Interstitial  | ✅          |

## Requisitos previos
- Complete la [Guía de inicio](../../index.md)
- Complete la [Guía de inicio de mediación](../get_started.md)

## Paso 1: Configurar PubMatic OpenWrap
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/pubmatic#step_1_set_up_pubmatic) o [iOS](https://developers.google.com/admob/ios/mediation/pubmatic#step_1_set_up_pubmatic), ya que será el mismo para todos.

## Paso 2: Configurar los ajustes de mediación para su bloque de anuncios de AdMob
Recomendamos seguir el tutorial para [Android](https://developers.google.com/admob/android/mediation/pubmatic#step_2) o [iOS](https://developers.google.com/admob/ios/mediation/pubmatic#step_2), ya que será el mismo para ambos.

## Paso 3: Importar el plugin SDK de PubMatic

=== "Android"
    1. Descargue el plugin para [Android](https://github.com/poingstudios/godot-admob-android/releases/latest).
    2. Extraiga el archivo `.zip`. Dentro, encontrará una carpeta `pubmatic`.
    3. Copie el contenido de la carpeta `pubmatic` y péguelo en la carpeta del plugin de Android en `res://addons/admob/android/bin/`.

=== "iOS"
    El adaptador de PubMatic ya **esta incluido** en la descarga estándar del plugin de iOS. Si siguió la [Guía de instalación de iOS](../../index.md#download-install), ya debería tener los archivos necesarios (`poing-godot-admob-pubmatic.gdip`) en su directorio `res://ios/plugins/`.

## Paso 4: Habilitar el plugin

=== "Android"
    Asegúrese de habilitar **PubMatic** en los **Ajustes del Proyecto** (bajo `Admob > Android > Mediation > Pubmatic`).

=== "iOS"
    Asegúrese de marcar tanto `Ad Mob` con `Ad Mob PubMatic` bajo la lista de Plugins en sus **Ajustes de Exportación de iOS** (además de ingresar su ID de aplicación de AdMob en la configuración de Plists).

## Paso 5: Agregar código requerido
No se requiere configuración de código adicional para la integración de este socio.
