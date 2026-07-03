# Soporte RGPD IAB

Esta guía describe los pasos necesarios para admitir el mensaje GDPR IAB TCF v2 como parte del SDK de UMP. Está pensado para combinarse con[empezar](get_started.md)que brinda una descripción general de cómo ejecutar su aplicación con el SDK de UMP y los conceptos básicos para configurar su mensaje. La siguiente guía es específica del mensaje GDPR IAB TCF v2.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/privacy/gdpr)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/privacy/gdpr)

## Requisitos previos

- Completa el[Guía de introducción](get_started.md)
- Crear un[Mensaje GDPR para aplicaciones](https://support.google.com/admob/answer/10113207).

## Retrasar la medición de la aplicación

De forma predeterminada, el SDK de anuncios de Google para móviles inicializa la medición de la aplicación y comienza a enviar datos de eventos a nivel de usuario a Google inmediatamente cuando se inicia la aplicación. Este comportamiento de inicialización garantiza que pueda habilitar las métricas de usuario de AdMob sin realizar cambios de código adicionales.

Sin embargo, si su aplicación requiere el consentimiento del usuario antes de que se puedan enviar estos eventos, puede retrasar la medición de la aplicación hasta que explícitamente[inicializar el SDK de anuncios para móviles](../../index.md)o cargar un anuncio.

=== "Androide"
Para retrasar la medición de la aplicación, agregue la siguiente etiqueta `<meta-data>` en su `res://android/build/AndroidManifest.xml`.
    ```xml
    <manifest>
        <application>
        <!-- Delay app measurement until MobileAds.initialize() is called. -->
        <meta-data
            android:name="com.google.android.gms.ads.DELAY_APP_MEASUREMENT_INIT"
            android:value="true"/>
        </application>
    </manifest>
    ```

=== "iOS"
Para retrasar la medición de la aplicación, agregue la clave `GADDelayAppMeasurementInit` con un valor booleano de `YES` al `Info.plist` de su aplicación del proyecto Xcode exportado. Puede realizar este cambio mediante programación:

    ```xml
    <key>GADDelayAppMeasurementInit</key>
    <true/>
    ```

## Revocación del consentimiento

[Revocabilidad del consentimiento](https://support.google.com/admob/answer/10113915)es un requisito del programa de consentimiento del usuario de privacidad y mensajería. Debe proporcionar un enlace en el menú de su aplicación que permita a los usuarios que deseen revocar el consentimiento hacerlo y luego presentar el mensaje de consentimiento a esos usuarios nuevamente.

Para lograr esto:

1. [Cargar un formulario](get_started.md#load-a-form-if-available)cada vez que el usuario inicia su aplicación, de modo que el formulario esté listo para mostrarse en caso de que el usuario desee cambiar su configuración de consentimiento.
2. Presente el formulario cuando el usuario seleccione el enlace en el menú de su aplicación.

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func present_form() -> void:
    	_consent_form.show(_on_consent_form_dismissed)
    	
    func _on_consent_form_dismissed(form_error : FormError):
    	# Handle dismissal by reloading form.
    	load_form()
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void PresentForm()
    {
        _consentForm.Show(OnConsentFormDismissed);
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        // Handle dismissal by reloading form.
        LoadForm();
    }
    ```

## Mediación
Siga los pasos en[Agregar socios publicitarios a los mensajes GDPR publicados](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages)para agregar sus socios de mediación a la lista de socios publicitarios. No hacerlo puede provocar que los socios no publiquen anuncios en su aplicación.

Los socios de mediación también pueden tener herramientas adicionales para ayudar con el cumplimiento del RGPD. Ver un socio específico[guía de integración](../../mediate/get_started.md)para más detalles.


## Solución de problemas

**Error 3.3: La última fecha de actualización de la cadena TC fue hace más de 13 meses**
- [Se debe volver a obtener el consentimiento.](https://support.google.com/admob/answer/9999955#grace-period-2)del usuario. Debes llamar a `UserMessagingPlatform.consent_information.update()` al inicio de cada sesión de la aplicación. Si la cadena TC ha caducado, el SDK de UMP indica que se debe volver a obtener el consentimiento configurando `ConsentInformation.ConsentStatus` en `ConsentInformation.ConsentStatus.REQUIRED`. Si aún no lo ha hecho, implemente una solicitud para[cargar y presentar un nuevo formulario UMP](get_started.md#present-the-form-if-required)en tu aplicación.

- Es posible que la cadena TC caduque a mitad de sesión, lo que genera una pequeña cantidad de errores "3.3". Y si en la siguiente sesión de la aplicación comienza a cargar anuncios al mismo tiempo que marca `UserMessagingPlatform.consent_information.update()`, esas solicitudes también podrían dar errores `3.3` hasta que se complete `UserMessagingPlatform.consent_information.update()`; sin embargo, esto debería ser una pequeña fracción de los errores generales "3,3" (menos del 0,1%). que se esperan.

