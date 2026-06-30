# Estrategias de privacidad

!!! note
    **Importante**: Verifique que tiene el permiso de **Gestión de cuentas** para completar la configuración de las estrategias de privacidad. Para obtener más información, consulte el artículo sobre [nuevos roles de usuario](https://support.google.com/admob/answer/2784628).

Esta guía explica las estrategias de privacidad disponibles en el SDK de Google Mobile Ads para ayudarle a entregar anuncios más relevantes respetando la privacidad del usuario.

Este documento se basa en:

- [SDK de Google Mobile Ads para Android - Estrategias de Privacidad](https://developers.google.com/admob/android/privacy/strategies)
- [SDK de Google Mobile Ads para iOS - Estrategias de Privacidad](https://developers.google.com/admob/ios/privacy/strategies)

## ID de primera parte del editor

El SDK de Google Mobile Ads introdujo el ID de primera parte del editor para ayudarle a entregar anuncios más relevantes y personalizados usando datos recopilados de sus aplicaciones.

El ID de primera parte del editor está habilitado por defecto, pero puede desactivarlo usando los siguientes métodos.

=== "GDScript"

    ```gdscript
    # Desactiva el ID de primera parte del editor.
    MobileAds.set_publisher_first_party_id_enabled(false)
    ```

=== "C#"

    ```csharp
    // Desactiva el ID de primera parte del editor.
    MobileAds.SetPublisherFirstPartyIDEnabled(false);
    ```

!!! note
    **Consejo:** El ID de primera parte del editor requiere el SDK de Google Mobile Ads versión 22.6.0 o superior para Android, y 10.14.0 o superior para iOS.
