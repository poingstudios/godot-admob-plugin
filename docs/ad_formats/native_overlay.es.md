# Anuncios superpuestos nativos

Los anuncios nativos superpuestos son un formato de anuncio especializado que le permite mostrar una[Anuncio nativo](https://support.google.com/admob/answer/6329630)encima del contenido de su aplicación. A diferencia de los anuncios nativos estándar que requieren que usted mismo cree la interfaz de usuario, los anuncios nativos superpuestos utilizan **Plantillas** para brindar una experiencia consistente y fácil de integrar, similar a otras plataformas.

!!! nota
Este formato es ideal para juegos y aplicaciones que desean una apariencia nativa sin la complejidad del diseño manual de la interfaz de usuario.

## Requisitos previos

Antes de continuar, haga lo siguiente:

- Completa el[Guía de introducción](../index.md).

## Pruebe siempre con anuncios de prueba

La siguiente tabla contiene ID de bloques de anuncios que puede utilizar para solicitar anuncios de prueba. Se han configurado especialmente para devolver anuncios de prueba en lugar de anuncios de producción para cada solicitud, lo que hace que su uso sea seguro.

Sin embargo, después de registrar una aplicación en la interfaz web de AdMob y crear sus propios ID de bloque de anuncios para usar en su aplicación, explícitamente[configure su dispositivo como dispositivo de prueba](../enable_test_ads.md)durante el desarrollo.

=== "Androide"

    ```
    ca-app-pub-3940256099942544/2247696110
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/3986624511
    ```

## Implementación

Los pasos principales para integrar anuncios superpuestos nativos son:

1. Cargar el anuncio nativo
2. Definir el estilo de la plantilla
3. renderizar la plantilla
4. Escuche eventos publicitarios
5. Mostrar/Ocultar o destruir el anuncio

### Cargar el anuncio nativo

La carga de un anuncio nativo se realiza utilizando el método `load()` en la clase `NativeOverlayAd`. Debe proporcionar un ID de bloque de anuncios, una "AdRequest", "NativeAdOptions" y una devolución de llamada de finalización.

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

### Definir el estilo de la plantilla

Puede utilizar `NativeTemplateStyle` para personalizar el aspecto del anuncio. Hay dos plantillas principales disponibles: `PEQUEÑA` y `MEDIA`.

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

### Posiciones de anuncios

Puede colocar el anuncio en varias posiciones predefinidas o en una coordenada XY personalizada utilizando la clase `AdPosition`.

- `PosiciónAd.TOP`
- `Posición del anuncio.BOTTOM`
- `PosicionAd.CENTRO`
- `PosiciónAd.TOP_LEFT` / `PosiciónAd.TOP_RIGHT`
- `PosiciónAd.BOTTOM_LEFT` / `PosiciónAd.BOTTOM_RIGHT`
- `AdPosition.personalizado(x, y)`

### Escuche eventos publicitarios

Para manejar las interacciones del usuario, puede utilizar la propiedad `ad_listener` de la instancia `NativeOverlayAd`.

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

### Mostrar/Ocultar y destruir

Una vez renderizado, puedes controlar la visibilidad del anuncio o destruirlo por completo para liberar recursos.

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

## Mejores prácticas

- **Destrucción**: llame siempre a `destroy()` cuando ya no necesite el anuncio para evitar pérdidas de memoria en plataformas nativas.
- **Carga en segundo plano**: Puede cargar anuncios en segundo plano y solo llamar a `render_template()` cuando esté listo para mostrarlos.
- **Elección de plantilla**: utilice plantillas "PEQUEÑAS" para listas o espacios reducidos, y "MEDIO" para ubicaciones más destacadas, como pantallas de transición de niveles.

## Recursos adicionales

- [Proyecto de muestra](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): consulte la pestaña "Nativo" para obtener una implementación completa.
