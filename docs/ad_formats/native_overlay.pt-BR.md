# Anúncios Native Overlay

Os anúncios Native Overlay são um formato de anúncio especializado que permite exibir um [Anúncio Nativo](https://support.google.com/admob/answer/6329630) por cima do conteúdo do seu aplicativo. Ao contrário dos anúncios nativos padrão, que exigem que você crie a interface do usuário por conta própria, os anúncios Native Overlay usam **Modelos (Templates)** para fornecer uma experiência consistente e fácil de integrar, semelhante a outras plataformas.

!!! note
    Este formato é ideal para jogos e aplicativos que desejam uma aparência nativa (look-and-feel) sem a complexidade do layout de interface manual.

## Pré-requisitos

Antes de continuar, faça o seguinte:

- Complete o [Guia de Primeiros Passos](../index.md).

## Sempre teste com anúncios de teste

A tabela a seguir contém os IDs de blocos de anúncios que você pode usar para solicitar anúncios de teste. Eles foram configurados especialmente para retornar anúncios de teste em vez de anúncios de produção para cada solicitação, tornando seu uso seguro.

No entanto, depois de registrar um aplicativo na interface web do AdMob e criar seus próprios IDs de blocos de anúncios para usar no seu aplicativo, [configure explicitamente seu dispositivo como um dispositivo de teste](../enable_test_ads.md) durante o desenvolvimento.

=== "Android"

    ```
    ca-app-pub-3940256099942544/2247696110
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/3986624511
    ```

## Implementação

As principais etapas para integrar anúncios native overlay são:

1. Carregar o anúncio nativo
2. Definir o estilo do modelo
3. Renderizar o modelo
4. Escutar eventos do anúncio
5. Mostrar/Ocultar ou Destruir o anúncio

### Carregar o anúncio nativo

O carregamento de um anúncio nativo é realizado usando o método `load()` na classe [`NativeOverlayAd`](../reference/classes/NativeOverlayAd.md). Você precisa fornecer um ID de bloco de anúncio, um [`AdRequest`](../reference/classes/AdRequest.md), [`NativeAdOptions`](../reference/classes/NativeAdOptions.md) e um callback de conclusão.

=== "GDScript"

    ```gdscript linenums="1"
    var _native_overlay_ad: NativeOverlayAd
    
    # These ad units are configured to always serve test ads.
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/2247696110"
            return "ca-app-pub-3940256099942544/3986624511"
    
    func _load_native_ad() -> void:
        var ad_request := AdRequest.new()
        var options := NativeAdOptions.new()
        
        # Optional: configure options
        options.ad_choices_placement = AdChoicesPlacement.Values.TOP_RIGHT
        options.media_aspect_ratio = NativeMediaAspectRatio.Values.ANY
    
        NativeOverlayAd.load(_ad_unit_id, ad_request, options, _on_ad_load_finished)
    
    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        if error:
            print("Native ad failed to load: ", error.message)
            return
        
        print("Native ad loaded successfully")
        _native_overlay_ad = ad
        _render_native_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    private NativeOverlayAd _nativeOverlayAd;
    
    // These ad units are configured to always serve test ads.
    private string _adUnitId => OS.GetName() == "Android" 
        ? "ca-app-pub-3940256099942544/2247696110" 
        : "ca-app-pub-3940256099942544/3986624511";
    
    private void LoadNativeAd()
    {
        var adRequest = new AdRequest();
        var options = new NativeAdOptions();
    
        // Optional: configure options
        options.AdChoicesPlacement = AdChoicesPlacement.Values.TopRight;
        options.MediaAspectRatio = NativeMediaAspectRatio.Values.Any;
    
        NativeOverlayAd.Load(_adUnitId, adRequest, options, OnAdLoadFinished);
    }
    
    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        if (error != null)
        {
            GD.Print("Native ad failed to load: " + error.Message);
            return;
        }
    
        GD.Print("Native ad loaded successfully");
        _nativeOverlayAd = ad;
        RenderNativeAd();
    }
    ```

### Definir o estilo do modelo

Você pode usar [`NativeTemplateStyle`](../reference/classes/NativeTemplateStyle.md) e [`NativeTemplateTextStyle`](../reference/classes/NativeTemplateTextStyle.md) para personalizar a aparência do anúncio. Existem dois modelos principais disponíveis: `SMALL` e `MEDIUM`.

=== "GDScript"

    ```gdscript linenums="1"
    func _render_native_ad() -> void:
        var style := NativeTemplateStyle.new()
        
        # Choose template: SMALL or MEDIUM
        style.template_id = NativeTemplateStyle.MEDIUM
        
        # Customize background color
        style.main_background_color = Color.WHITE
        
        # Customize Call To Action (CTA) button
        var cta_style := NativeTemplateTextStyle.new()
        cta_style.background_color = Color.DODGER_BLUE
        cta_style.text_color = Color.WHITE
        cta_style.font_size = 15.0
        cta_style.style = NativeTemplateFontStyle.Values.BOLD
        
        style.call_to_action_text = cta_style
        
        # Render the template at a specific position
        _native_overlay_ad.render_template(style, AdPosition.BOTTOM)
    ```

=== "C#"

    ```csharp linenums="1"
    private void RenderNativeAd()
    {
        var style = new NativeTemplateStyle();
    
        // Choose template: Small or Medium
        style.TemplateId = NativeTemplateStyle.Medium;
    
        // Customize background color
        style.MainBackgroundColor = Colors.White;
    
        // Customize Call To Action (CTA) button
        var ctaStyle = new NativeTemplateTextStyle();
        ctaStyle.BackgroundColor = Colors.DodgerBlue;
        ctaStyle.TextColor = Colors.White;
        ctaStyle.FontSize = 15.0f;
        ctaStyle.Style = NativeTemplateFontStyle.Bold;
    
        style.CallToActionText = ctaStyle;
    
        // Render the template at a specific position
        _nativeOverlayAd.RenderTemplate(style, AdPosition.Bottom);
    }
    ```

### Posições do Anúncio

Você pode colocar o anúncio em várias posições predefinidas ou em uma coordenada XY personalizada usando os alinhamentos predefinidos de [`AdPosition`](../reference/classes/AdPosition.md).

- `AdPosition.TOP`
- `AdPosition.BOTTOM`
- `AdPosition.CENTER`
- `AdPosition.TOP_LEFT` / `AdPosition.TOP_RIGHT`
- `AdPosition.BOTTOM_LEFT` / `AdPosition.BOTTOM_RIGHT`
- `AdPosition.custom(x, y)`

### Escutar eventos do anúncio

Para gerenciar as interações do usuário, você pode usar a propriedade `ad_listener` da instância do [`NativeOverlayAd`](../reference/classes/NativeOverlayAd.md), que aceita um [`AdListener`](../reference/listeners/AdListener.md).

=== "GDScript"

    ```gdscript linenums="1"
    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        # ... load check ...
        
        ad.ad_listener.on_ad_clicked = func(): print("Ad Clicked")
        ad.ad_listener.on_ad_impression = func(): print("Ad Impression")
        ad.ad_listener.on_ad_opened = func(): print("Ad Opened")
        ad.ad_listener.on_ad_closed = func(): print("Ad Closed")
    ```

=== "C#"

    ```csharp linenums="1"
    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        // ... load check ...
    
        ad.AdListener.OnAdClicked = () => GD.Print("Ad Clicked");
        ad.AdListener.OnAdImpression = () => GD.Print("Ad Impression");
        ad.AdListener.OnAdOpened = () => GD.Print("Ad Opened");
        ad.AdListener.OnAdClosed = () => GD.Print("Ad Closed");
    }
    ```

### Mostrar/Ocultar e Destruir

Depois de renderizado, você pode controlar a visibilidade do anúncio ou destruí-lo completamente para liberar recursos.

=== "GDScript"

    ```gdscript linenums="1"
    # To hide the ad
    _native_overlay_ad.hide()
    
    # To show it again
    _native_overlay_ad.show()
    
    # To destroy it (required when finished)
    _native_overlay_ad.destroy()
    _native_overlay_ad = null
    ```

=== "C#"

    ```csharp linenums="1"
    // To hide the ad
    _nativeOverlayAd.Hide();
    
    // To show it again
    _nativeOverlayAd.Show();
    
    // To destroy it (required when finished)
    _nativeOverlayAd.Destroy();
    _nativeOverlayAd = null;
    ```

## Boas práticas

- **Destruição**: Sempre chame `destroy()` quando não precisar mais do anúncio para evitar vazamentos de memória em plataformas nativas.
- **Carregamento em Segundo Plano**: Você pode carregar anúncios em segundo plano e chamar apenas `render_template()` quando estiver pronto para exibi-los.
- **Escolha do Modelo**: Use modelos `SMALL` para listas ou espaços reduzidos, e `MEDIUM` para posicionamentos mais proeminentes, como telas de transição de nível.

## Recursos adicionais

- [Projeto de Exemplo](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): Consulte a aba `Native` para ver uma implementação completa.
