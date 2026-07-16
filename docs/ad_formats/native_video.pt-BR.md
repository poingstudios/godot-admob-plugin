---
hide:
  - toc
---

# Vídeos de anúncios nativos

Os anúncios nativos fornecem acesso a um objeto `MediaContent` que é usado para obter informações sobre o conteúdo de mídia, que pode ser vídeo ou imagem. Também é usado para controlar a reprodução de anúncios em vídeo e ouvir eventos de reprodução. Você pode obter o objeto `MediaContent` chamando `get_media_content()` no anúncio carregado.

## MediaContent

O objeto `MediaContent` contém informações como a proporção e a duração de um vídeo. O trecho a seguir mostra como obter a proporção e a duração de um anúncio nativo.

=== "GDScript"

    ```gdscript linenums="1"
    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        if error:
            return
        
        _native_overlay_ad = ad
        
        var media_content := ad.get_media_content()
        if media_content:
            var aspect_ratio := media_content.get_aspect_ratio()
            if media_content.has_video_content():
                var duration := media_content.get_duration()
    ```

=== "C#"

    ```csharp linenums="1"
    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        if (error != null) return;
        
        _nativeOverlayAd = ad;
        
        var mediaContent = ad.GetMediaContent();
        if (mediaContent != null)
        {
            float aspectRatio = mediaContent.GetAspectRatio();
            if (mediaContent.HasVideoContent())
            {
                float duration = mediaContent.GetDuration();
            }
        }
    }
    ```

## Callbacks para eventos de vídeo

Para lidar com eventos específicos de vídeo, crie um objeto `VideoLifecycleCallbacks` e atribua-o ao `VideoController` via `video_lifecycle_callbacks`. Em seguida, defina apenas os callbacks que lhe interessam.

=== "GDScript"

    ```gdscript linenums="1"
    var callbacks := VideoLifecycleCallbacks.new()
    callbacks.on_video_start = func(): print("Vídeo iniciado.")
    callbacks.on_video_play = func(): print("Vídeo reproduzido.")
    callbacks.on_video_pause = func(): print("Vídeo pausado.")
    callbacks.on_video_end = func(): print("Vídeo finalizado.")
    callbacks.on_video_mute = func(is_muted: bool): print("Vídeo silenciado: ", is_muted)
    
    media_content.get_video_controller().video_lifecycle_callbacks = callbacks
    ```

=== "C#"

    ```csharp linenums="1"
    var callbacks = new VideoLifecycleCallbacks();
    callbacks.OnVideoStart = () => GD.Print("Vídeo iniciado.");
    callbacks.OnVideoPlay = () => GD.Print("Vídeo reproduzido.");
    callbacks.OnVideoPause = () => GD.Print("Vídeo pausado.");
    callbacks.OnVideoEnd = () => GD.Print("Vídeo finalizado.");
    callbacks.OnVideoMute = (isMuted) => GD.Print($"Vídeo silenciado: {isMuted}");
    
    mediaContent.GetVideoController().VideoLifecycleCallbacks = callbacks;
    ```

## Notas Importantes

> [!WARNING]
> **Requisito do MediaView**
>
> Se você carregar um anúncio em vídeo usando o modelo `SMALL`, verá um aviso de problema de implementação indicando:
> `MediaView not used for main image or video asset. Use MediaView instead of ImageView to show the main image or video asset`.
>
> Isso ocorre porque o SDK oficial do Google Mobile Ads exige um `MediaView` visível para renderizar o vídeo, mas o layout compacto do modelo `SMALL` não suporta ou inclui um funcional por padrão. Se o seu bloco de anúncios veicula anúncios em vídeo, você **deve usar o modelo `MEDIUM`**, que inclui um `MediaView` integrado.

> [!NOTE]
> **Valores do MediaContent (Duração e Proporção)**
>
> Valores como duração do vídeo e proporção de tela (aspect ratio) do objeto `MediaContent` retornarão `0.0` se forem consultados imediatamente no callback `on_ad_loaded`. Você deve consultá-los **após** chamar `render_template()`, uma vez que a exibição do anúncio tenha sido inflada e configurada na tela.


