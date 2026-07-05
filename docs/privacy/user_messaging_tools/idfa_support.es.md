# Soporte IDFA

Esta guía describe los pasos necesarios para admitir el mensaje IDFA como parte del SDK de UMP. Está pensado para combinarse con[empezar](get_started.md)que brinda una descripción general de cómo ejecutar su aplicación con el SDK de UMP y los conceptos básicos para configurar su mensaje. La siguiente guía es específica del mensaje IDFA.

!!! nota
Si habilita los mensajes GDPR e IDFA, consulte[Qué mensaje verán tus usuarios](https://support.google.com/admob/answer/10115027#which_message)para los posibles resultados

Este documento se basa en:

- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/privacy/idfa)

## Requisitos previos

- Completa el[Guía de introducción](get_started.md)
- Crear un[mensaje IDFA](https://support.google.com/admob/answer/10115331)

## Actualizar información.plist

Si planea utilizar el SDK de UMP para manejar los requisitos de transparencia de seguimiento de aplicaciones (ATT) de Apple, asegúrese de haber creado, configurado y publicado su[Mensaje explicativo de IDFA](https://support.google.com/admob/answer/10115027)en la interfaz de usuario de AdMob.


Para que UMP SDK muestre un mensaje de alerta personalizado en el cuadro de diálogo del sistema iOS, actualice su `Info.plist` para agregar la clave `NSUserTrackingUsageDescription` con una cadena de mensaje personalizada que describa su uso.

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

La descripción de uso aparece como parte del cuadro de diálogo ATT cuando presenta el formulario de consentimiento:

![idfa-alert](https://developers.google.com/static/admob/ump/images/idfa-alert.png)

Luego, vincule el marco `AppTrackingTransparency`:

![link-att-framework](https://developers.google.com/static/admob/ump/images/link-att-framework.png)

¡Eso es todo! Su aplicación ahora mostrará un mensaje explicativo de IDFA antes del cuadro de diálogo ATT de IDFA.

### Pruebas

Mientras realiza la prueba, recuerde que el cuadro de diálogo IDFA ATT solo aparece una vez desde[`solicitud de autorización de seguimiento`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/requesttrackingauthorization(completionhandler:)) es una solicitud única. El SDK de UMP solo tiene un formulario disponible para cargar si el estado de autorización es[`ATTrackingManagerAuthorizationStatusNotDetermined`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/authorizationstatus/notdetermined?language=objc).

Para que la alerta aparezca por segunda vez, debe desinstalar y reinstalar su aplicación en su dispositivo de prueba.
