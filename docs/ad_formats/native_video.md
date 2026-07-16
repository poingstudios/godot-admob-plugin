---
hide:
  - toc
---

# Native ad videos

Native ads provide access to a `MediaContent` object that is used to get information about media content, which could be video or an image. It is also used to control video ad playback and listen for playback events. You can obtain the `MediaContent` object by calling `get_media_content()` on the loaded ad.

## MediaContent

The `MediaContent` object contains information such as the aspect ratio and duration of a video. The following snippet shows how to get the aspect ratio and duration of a native ad.

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

## Callbacks for video events

To handle specific video events, create a `VideoLifecycleCallbacks` object and assign it to the `VideoController` via `video_lifecycle_callbacks`. Then, set only the callbacks you care about.

=== "GDScript"

    ```gdscript linenums="1"
    var callbacks := VideoLifecycleCallbacks.new()
    callbacks.on_video_start = func(): print("Video started.")
    callbacks.on_video_play = func(): print("Video played.")
    callbacks.on_video_pause = func(): print("Video paused.")
    callbacks.on_video_end = func(): print("Video ended.")
    callbacks.on_video_mute = func(is_muted: bool): print("Video isMuted: ", is_muted)
    
    media_content.get_video_controller().video_lifecycle_callbacks = callbacks
    ```

=== "C#"

    ```csharp linenums="1"
    var callbacks = new VideoLifecycleCallbacks();
    callbacks.OnVideoStart = () => GD.Print("Video started.");
    callbacks.OnVideoPlay = () => GD.Print("Video played.");
    callbacks.OnVideoPause = () => GD.Print("Video paused.");
    callbacks.OnVideoEnd = () => GD.Print("Video ended.");
    callbacks.OnVideoMute = (isMuted) => GD.Print($"Video isMuted: {isMuted}");
    
    mediaContent.GetVideoController().VideoLifecycleCallbacks = callbacks;
    ```

## Important Notes

> [!WARNING]
> **MediaView Requirement**
>
> If you load a video ad using the `SMALL` template, you will see an implementation issue/warning stating:
> `MediaView not used for main image or video asset. Use MediaView instead of ImageView to show the main image or video asset`.
>
> This happens because the official Google Mobile Ads SDK requires a visible `MediaView` to render the video, but the compact `SMALL` template layout does not support or include a functional one by default. If your ad unit serves video ads, you **must use the `MEDIUM` template** which includes a built-in `MediaView`.

> [!NOTE]
> **MediaContent Values (Duration & Aspect Ratio)**
>
> Values like video duration and aspect ratio from the `MediaContent` object will return `0.0` if queried immediately inside the `on_ad_loaded` callback. You must query them **after** calling `render_template()`, once the ad view has been inflated and laid out.


