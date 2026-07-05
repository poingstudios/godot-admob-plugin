# Smart Banner ⚠️ (descontinuado)

Este documento é baseado em:

- [Documentação de Smart Banners do Google Mobile Ads SDK para Android](https://developers.google.com/admob/android/banner/smart)
- [Documentação de Smart Banners do Google Mobile Ads SDK para iOS](https://developers.google.com/admob/ios/banner/smart)

!!! note

    Tente utilizar os novos [banners adaptativos](anchored_adaptive.md) no lugar.

Para usar Smart Banners, use a propriedade `AdSize.SMART_BANNER` (ou `AdSize.SmartBanner` no C#) para o tamanho do anúncio ao criar um AdView. Por exemplo:

=== "GDScript"

    ```gdscript linenums="1"
    # Cria um Smart Banner no topo da tela.
    var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    // Cria um Smart Banner no topo da tela.
    var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
    ```
