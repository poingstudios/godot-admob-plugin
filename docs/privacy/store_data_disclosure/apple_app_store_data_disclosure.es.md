# Divulgación de datos de la Apple App Store

Apple requiere que los desarrolladores que publican aplicaciones en la App Store proporcionen [cierta información](https://developer.apple.com/app-store/app-privacy-details/) sobre el uso de datos de sus aplicaciones. Esta guía explica las prácticas de recopilación de datos del SDK de Google Mobile Ads para facilitar a los desarrolladores AdMob responder las preguntas en App Store Connect.

!!! note
    **Importante**: Como desarrollador de la aplicación, usted es el único responsable de decidir cómo responder a las preguntas de privacidad de App Store Connect con respecto a las prácticas de recopilación y uso de datos de su aplicación.

Este documento se basa en:

- [SDK de Google Mobile Ads para iOS - Divulgación de datos de la Apple App Store](https://developers.google.com/admob/ios/privacy/data-disclosure)

## Datos recopilados por el SDK de Google Mobile Ads

Para mejorar el rendimiento de AdMob, el SDK de Google Mobile Ads puede recopilar cierta información de las aplicaciones, incluyendo:

| Tipo de Datos | Propósito |
|---------------|-----------|
| **Dirección IP** | Puede usarse para estimar la ubicación general de un dispositivo. |
| **Registros de errores no relacionados con el usuario** | Pueden usarse para diagnosticar problemas y mejorar el SDK. La información de diagnóstico también puede usarse con fines de publicidad y análisis. |
| **Datos de rendimiento asociados al usuario** | Como tiempo de inicio, tasa de bloqueo o uso de energía, que pueden usarse para evaluar el comportamiento del usuario, comprender la efectividad de las funciones existentes y planificar nuevas funciones. Los datos de rendimiento también pueden usarse para mostrar anuncios, incluyendo el uso compartido con otras entidades que muestran anuncios. |
| **Un ID del dispositivo** | Como el identificador de publicidad del dispositivo u otros identificadores de dispositivo vinculados a la aplicación o desarrollador, que pueden usarse con fines de publicidad y análisis de terceros. |
| **Datos de publicidad** | Como anuncios que el usuario ha visto, pueden usarse para impulsar funciones de análisis y publicidad. |
| **Otras interacciones del producto del usuario** | Como toques de inicio de la aplicación e información de interacción, como visualizaciones de video, pueden usarse para mejorar el rendimiento de la publicidad. |

Todos los datos del usuario recopilados por el SDK de Google Mobile Ads se cifran en tránsito usando el protocolo Transport Layer Security (TLS).

## Archivos de manifiesto de privacidad de Apple

El SDK de Google Mobile Ads versión 11.2.0 y superior admite declaraciones de manifiesto de privacidad. Usted es responsable de verificar el manifiesto de privacidad y asegurarse de que las divulgaciones de datos de su aplicación estén actualizadas.

Consulte la [documentación de Apple](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests) para detalles sobre cómo interpretar un informe de privacidad y su [actualización de aplicación](https://developer.apple.com/news/?id=pvszzano) para los requisitos de envío de aplicaciones.

## Divulgaciones de datos adicionales

Si está usando funciones opcionales del producto que involucren datos adicionales (como informes avanzados) o participando en pruebas de nuevas funciones del producto que involucren datos adicionales, asegúrese de verificar si esas funciones o pruebas requieren divulgaciones de datos adicionales.

Si está usando una versión anterior del SDK de Google Mobile Ads, considere actualizar a la versión más reciente para asegurarse de que las divulgaciones de su aplicación sean precisas. El SDK de Google Mobile Ads continuará siendo actualizado con el tiempo. Asegúrese de verificar y actualizar sus divulgaciones según sea necesario.
