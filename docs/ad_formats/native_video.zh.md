---
hide:
  - toc
---

# 原生视频广告

原生广告提供了对 `MediaContent` 对象的访问，该对象用于获取关于媒体内容（可以是视频或图片）的信息。它还用于控制视频广告的播放并监听播放事件。您可以通过在加载的广告上调用 `get_media_content()` 来获取 `MediaContent` 对象。

## MediaContent

`MediaContent` 对象包含视频的宽高比和时长等信息。以下代码片段展示了如何获取原生广告的宽高比和时长。

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

## 视频事件回调

要处理特定的视频事件，请创建一个 `VideoLifecycleCallbacks` 对象，并通过 `video_lifecycle_callbacks` 将其分配给 `VideoController`。然后，仅设置您关心的回调。

=== "GDScript"

    ```gdscript linenums="1"
    var callbacks := VideoLifecycleCallbacks.new()
    callbacks.on_video_start = func(): print("视频开始播放。")
    callbacks.on_video_play = func(): print("视频播放。")
    callbacks.on_video_pause = func(): print("视频暂停。")
    callbacks.on_video_end = func(): print("视频播放结束。")
    callbacks.on_video_mute = func(is_muted: bool): print("视频静音状态: ", is_muted)
    
    media_content.get_video_controller().video_lifecycle_callbacks = callbacks
    ```

=== "C#"

    ```csharp linenums="1"
    var callbacks = new VideoLifecycleCallbacks();
    callbacks.OnVideoStart = () => GD.Print("视频开始播放。");
    callbacks.OnVideoPlay = () => GD.Print("视频播放。");
    callbacks.OnVideoPause = () => GD.Print("视频暂停。");
    callbacks.OnVideoEnd = () => GD.Print("视频播放结束。");
    callbacks.OnVideoMute = (isMuted) => GD.Print($"视频静音状态: {isMuted}");
    
    mediaContent.GetVideoController().VideoLifecycleCallbacks = callbacks;
    ```

## 重要提示

> [!WARNING]
> **MediaView 要求**
>
> 如果您使用 `SMALL` 模板加载视频广告，您会看到一条实现问题/警告，指出：
> `MediaView not used for main image or video asset. Use MediaView instead of ImageView to show the main image or video asset`。
>
> 这是因为官方 Google Mobile Ads SDK 需要可见的 `MediaView` 来渲染视频，但紧凑的 `SMALL` 模板布局默认不支持或包含一个功能性的视图。如果您的广告单元提供视频广告，您**必须使用包含内置 `MediaView` 的 `MEDIUM` 模板**。

> [!NOTE]
> **MediaContent 数值（时长与宽高比）**
>
> 如果在 `on_ad_loaded` 回调中立即查询，`MediaContent` 对象中的视频时长和宽高比等数值将返回 `0.0`。您必须在调用 `render_template()` **之后**进行查询，此时广告视图已被实例化并完成布局。

