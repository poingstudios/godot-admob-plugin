# Divulgación de datos de Google Play

En mayo de 2021, Google Play [anunció la nueva sección de Seguridad de datos](https://android-developers.googleblog.com/2021/05/new-safety-section-in-google-play-will.html), que es una divulgación proporcionada por el desarrollador sobre las prácticas de recopilación, uso y seguridad de datos de la aplicación.

Esta página puede ayudarlo a completar los requisitos para esta divulgación de datos con respecto a su uso del Plugin Godot AdMob. En esta página, puede encontrar información sobre si y cómo el SDK de Google Mobile Ads maneja los datos del usuario final, incluyendo cualquier configuración o ajustes aplicables que pueda controlar como desarrollador de la aplicación.

!!! note
    **Importante**: Como desarrollador de la aplicación, usted es el único responsable de decidir cómo responder al formulario de Seguridad de datos de Google Play con respecto a las prácticas de recopilación, uso y seguridad de datos de su aplicación.

Este documento se basa en:

- [SDK de Google Mobile Ads para Android - Divulgación de datos de Google Play](https://developers.google.com/admob/android/privacy/play-data-disclosure)

## Cómo usar la información en esta página

Esta página enumera los datos del usuario final recopilados por la última versión del SDK de Google Mobile Ads. Si está usando una versión anterior, considere actualizar a la versión más reciente para asegurarse de que las divulgaciones de su aplicación sean precisas.

Para completar su divulgación de datos, puede usar la [guía sobre tipos de datos](https://developer.android.com/guide/topics/data/collect-share) de Android para ayudarlo a determinar qué tipos de datos y propósitos describen mejor los datos recopilados. En su divulgación de datos, asegúrese también de considerar cómo su aplicación específica comparte y usa los datos recopilados.

## Datos recopilados y compartidos automáticamente

El SDK de Google Mobile Ads recopila y comparte los siguientes tipos de datos *automáticamente* con fines de publicidad, análisis y prevención de fraudes.

| Datos | Por defecto, el SDK de Google Mobile Ads... |
|-------|---------------------------------------------|
| **Dirección IP** | Recopila la dirección IP del dispositivo, que puede usarse para estimar la ubicación general de un dispositivo. |
| **Interacciones del producto del usuario** | Recopila interacciones del producto del usuario e información de interacción, incluyendo lanzamiento de la aplicación, toques y visualizaciones de video. |
| **Información de diagnóstico** | Recopila información relacionada con el rendimiento de su aplicación y el SDK, incluyendo tiempo de inicio, tasa de bloqueo y uso de energía. |
| **Identificadores de dispositivo y cuenta** | Recopila el [ID de publicidad de Android](https://support.google.com/googleplay/android-developer/answer/6048248), el [ID definido por la aplicación](https://developer.android.com/training/articles/app-set-id) y, si corresponde, otros identificadores relacionados con cuentas conectadas en el dispositivo. |

Todos los datos del usuario recopilados por el SDK de Google Mobile Ads se cifran en tránsito usando el protocolo Transport Layer Security (TLS).

## Manejo de datos

La recopilación del ID de publicidad de Android es opcional. El ID de publicidad puede ser restablecido o eliminado por los usuarios usando los controles de ID de publicidad en el menú de configuración de Android. Como desarrollador de la aplicación, puede evitar la recopilación de ID de publicidad [actualizando el archivo de manifiesto de la aplicación](https://support.google.com/googleplay/android-developer/answer/6048248).

Ciertas otras funciones en el SDK de Google Mobile Ads, como la función [Limited Ads](https://support.google.com/admob/answer/10105530), también pueden desactivar la transmisión del ID de publicidad y otros datos.

## Datos recopilados y compartidos según su uso

Si está usando funciones opcionales del producto que involucren datos adicionales (como informes avanzados) o participando en pruebas de nuevas funciones del producto que involucren datos adicionales, asegúrese de verificar si esas funciones o pruebas requieren divulgaciones de datos adicionales.

## Otros recursos útiles

- [Publicación del blog](https://android-developers.googleblog.com/2021/10/launching-data-safety-in-play-console.html) anunciando el formulario de Seguridad de datos en Google Play Console.
- El formulario de Seguridad de datos de Play Console está disponible en la página [Contenido de la aplicación](https://play.google.com/console/developers/app/app-content/summary).
