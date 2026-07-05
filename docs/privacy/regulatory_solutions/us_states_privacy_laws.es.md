# Cumplimiento de las leyes de privacidad de los estados de EE. UU.
!!! nota
**Importante**: Verifique que tiene permiso de **Administración de cuentas** para completar la configuración de Consentimiento de la UE y GDPR, CCPA y Plataforma de mensajería de usuario. Para obtener más información, consulte lo siguiente.[nuevos roles de usuario](https://support.google.com/admob/answer/2784628)artículo.
Para ayudar a los editores a cumplir con[Leyes de privacidad de los estados de EE. UU.](https://support.google.com/admob/answer/9561022), el SDK de anuncios de Google para móviles permite a los editores utilizar dos parámetros diferentes para indicar si Google debe habilitar[procesamiento de datos restringido (RDP)](https://business.safety.google/rdp/). El SDK ofrece a los editores la capacidad de configurar RDP en un nivel de solicitud de anuncios utilizando las siguientes señales:

- PDR de Google
- [definido por IAB](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf)`IABUSPrivacy_String`

Cuando se utiliza cualquiera de los parámetros, Google restringe la forma en que utiliza ciertos identificadores únicos y otros datos procesados ​​en la prestación de servicios a los editores. Como resultado, Google sólo mostrará anuncios no personalizados. Estos parámetros anulan la configuración de RDP en la interfaz de usuario.

Los editores deben decidir por sí mismos cómo el procesamiento de datos restringido puede respaldar sus planes de cumplimiento y cuándo debe habilitarse. Es posible utilizar ambos parámetros opcionales al mismo tiempo, aunque tienen el mismo efecto en la publicación de anuncios de Google.

Esta guía está destinada a ayudar a los editores a comprender los pasos necesarios para habilitar estas opciones por solicitud de anuncio.

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/privacy/us-states)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/privacy/us-states)

## Señal RDP

Para notificar a Google que se debe habilitar RDP utilizando la señal de Google, inserte la clave rdp como parámetro adicional con un valor de "1".

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["rdp"] = 1
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("rdp", "1");
    ```

!!! nota
**Consejo:** Puede utilizar el rastreo de red o una herramienta proxy como[carlos](https://www.charlesproxy.com/)para capturar el tráfico HTTPS de su aplicación e inspeccionar las solicitudes de anuncios en busca de un parámetro **&rdp=**.
## Señal IAB

Para notificar a Google que se debe habilitar RDP usando la señal de IAB, inserte la clave `IABUSPrivacy_String` como parámetro adicional. Asegúrese de que el valor de cadena que utilice cumpla con las[especificación IAB](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf).

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["IABUSPrivacy_String"] = "IAB_STRING"
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("IABUSPrivacy_String", "IAB_STRING");
    ```

!!! nota
**Consejo:** Puede utilizar el rastreo de red o una herramienta proxy como[carlos](https://www.charlesproxy.com/)para capturar el tráfico HTTPS de su aplicación e inspeccionar las solicitudes de anuncios en busca de un parámetro **&us_privacy=**.
## Mediación

!!! nota
**Importante:** Verifique que tenga los permisos de cuenta necesarios para completar la configuración de mediación. Estos permisos incluyen acceso a la gestión de inventario, acceso a aplicaciones y funciones de privacidad y mensajería. Para obtener más información, consulte lo siguiente.[nuevos roles de usuario](https://support.google.com/admob/answer/2784628)artículo.
si usas[mediación](../../mediate/get_started.md), sigue los pasos en[Configuración de CPRA](https://support.google.com/admob/answer/10860309)para agregar sus socios de mediación a la lista de socios publicitarios de la CCPA en la interfaz de usuario de AdMob. Además, consulte la documentación de cada socio de la red publicitaria para determinar qué opciones ofrecen para ayudar a cumplir con la CCPA.
