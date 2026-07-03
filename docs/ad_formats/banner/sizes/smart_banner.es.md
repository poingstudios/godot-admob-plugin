# Banner inteligente ⚠️ (obsoleto)

Este documento se basa en:

- [Documentación de Android del SDK de anuncios de Google para móviles](https://developers.google.com/admob/android/banner/smart)
- [Documentación de iOS del SDK de anuncios de Google para móviles](https://developers.google.com/admob/ios/banner/smart)


!!! nota

Prueba el más nuevo[pancartas adaptables](anchored_adaptive.md)en cambio.

Para utilizar banners inteligentes, utilice la propiedad `AdSize.SMART_BANNER` (o `AdSize.SmartBanner` en C#) para el tamaño del anuncio al crear un AdView. Por ejemplo:

=== "GDScript"

    ```gdscript linenums="1"
    # Create a Smart Banner at the top of the screen.
    var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    // Create a Smart Banner at the top of the screen.
    var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
    ```
