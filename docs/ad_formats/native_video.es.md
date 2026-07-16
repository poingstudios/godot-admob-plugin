---
hide:
  - toc
---

# Videos de anuncios nativos

Los anuncios nativos proporcionan acceso a un objeto `MediaContent` que se utiliza para obtener información sobre el contenido multimedia, que puede ser video o imagen. También se usa para controlar la reproducción de anuncios en video y escuchar eventos de reproducción. Puede obtener el objeto `MediaContent` llamando a `get_media_content()` en el anuncio cargado.

## MediaContent

El objeto `MediaContent` contiene información como la relación de aspecto y la duración de un video. El siguiente fragmento muestra cómo obtener la relación de aspecto y la duración de un anuncio nativo.

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

## Callbacks para eventos de video

Para manejar eventos de video específicos, cree un objeto `VideoLifecycleCallbacks` y asígnelo al `VideoController` mediante `video_lifecycle_callbacks`. Luego, establezca solo los callbacks que le interesen.

=== "GDScript"

    ```gdscript linenums="1"
    var callbacks := VideoLifecycleCallbacks.new()
    callbacks.on_video_start = func(): print("Video iniciado.")
    callbacks.on_video_play = func(): print("Video reproducido.")
    callbacks.on_video_pause = func(): print("Video pausado.")
    callbacks.on_video_end = func(): print("Video finalizado.")
    callbacks.on_video_mute = func(is_muted: bool): print("Video silenciado: ", is_muted)
    
    media_content.get_video_controller().video_lifecycle_callbacks = callbacks
    ```

=== "C#"

    ```csharp linenums="1"
    var callbacks = new VideoLifecycleCallbacks();
    callbacks.OnVideoStart = () => GD.Print("Video iniciado.");
    callbacks.OnVideoPlay = () => GD.Print("Video reproducido.");
    callbacks.OnVideoPause = () => GD.Print("Video pausado.");
    callbacks.OnVideoEnd = () => GD.Print("Video finalizado.");
    callbacks.OnVideoMute = (isMuted) => GD.Print($"Video silenciado: {isMuted}");
    
    mediaContent.GetVideoController().VideoLifecycleCallbacks = callbacks;
    ```

## Notas importantes

> [!WARNING]
> **Requisito de MediaView**
>
> Si cargas un anuncio de video usando la plantilla `SMALL`, verás una advertencia de problema de implementación que indica:
> `MediaView not used for main image or video asset. Use MediaView instead of ImageView to show the main image or video asset`.
>
> Esto sucede porque el SDK oficial de Google Mobile Ads requiere un `MediaView` visible para renderizar el video, pero el diseño compacto de la plantilla `SMALL` no lo admite o incluye de forma predeterminada. Si tu bloque de anuncios publica anuncios de video, **debes usar la plantilla `MEDIUM`** que incluye un `MediaView` integrado.

> [!NOTE]
> **Valores de MediaContent (Duración y Relación de Aspecto)**
>
> Los valores como la duración del video y la relación de aspecto del objeto `MediaContent` devolverán `0.0` si se consultan inmediatamente dentro de la función de callback `on_ad_loaded`. Debes consultarlos **después** de llamar a `render_template()`, una vez que la vista del anuncio se haya inflado y diseñado en pantalla.


