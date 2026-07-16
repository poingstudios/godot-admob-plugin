---
hide:
  - toc
---

# ネイティブ動画広告

ネイティブ広告には、画像または動画に関する情報を取得するために使用される `MediaContent` オブジェクトが用意されています。これは、動画広告の再生の制御や、再生イベントをリッスンするためにも使用されます。ロードされた広告で `get_media_content()` を呼び出すことで `MediaContent` オブジェクトを取得できます。

## MediaContent

`MediaContent` オブジェクトには、動画のアスペクト比や再生時間などの情報が含まれています。次のスニペットは、ネイティブ広告のアスペクト比と再生時間を取得する方法を示しています。

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

## 動画イベントのコールバック

特定の動画イベントを処理するには、`VideoLifecycleCallbacks` オブジェクトを作成し、`video_lifecycle_callbacks` を介して `VideoController` に割り当てます。その後、必要なコールバックのみを設定します。

=== "GDScript"

    ```gdscript linenums="1"
    var callbacks := VideoLifecycleCallbacks.new()
    callbacks.on_video_start = func(): print("動画再生開始。")
    callbacks.on_video_play = func(): print("動画再生。")
    callbacks.on_video_pause = func(): print("動画一時停止。")
    callbacks.on_video_end = func(): print("動画再生終了。")
    callbacks.on_video_mute = func(is_muted: bool): print("動画ミュート状態: ", is_muted)
    
    media_content.get_video_controller().video_lifecycle_callbacks = callbacks
    ```

=== "C#"

    ```csharp linenums="1"
    var callbacks = new VideoLifecycleCallbacks();
    callbacks.OnVideoStart = () => GD.Print("動画再生開始。");
    callbacks.OnVideoPlay = () => GD.Print("動画再生。");
    callbacks.OnVideoPause = () => GD.Print("動画一時停止。");
    callbacks.OnVideoEnd = () => GD.Print("動画再生終了。");
    callbacks.OnVideoMute = (isMuted) => GD.Print($"動画ミュート状態: {isMuted}");
    
    mediaContent.GetVideoController().VideoLifecycleCallbacks = callbacks;
    ```

## 重要な注意点

> [!WARNING]
> **MediaViewの要件**
>
> `SMALL` テンプレートを使用して動画広告をロードすると、実装の問題に関する次のような警告が表示されます：
> `MediaView not used for main image or video asset. Use MediaView instead of ImageView to show the main image or video asset` (メインの画像または動画アセットにMediaViewが使用されていません。メインの画像または動画アセットを表示するには、ImageViewの代わりにMediaViewを使用してください)。
>
> これは、公式のGoogle Mobile Ads SDKが動画をレンダリングするために表示可能な `MediaView` を必要とするのに対し、コンパクトな `SMALL` テンプレートレイアウトにはデフォルトで機能するものが含まれていないためです。動画広告を配信する広告ユニットを使用する場合は、ビルトインの `MediaView` が含まれている **`MEDIUM` テンプレートを使用する必要があります**。

> [!NOTE]
> **MediaContent の値 (再生時間とアスペクト比)**
>
> `on_ad_loaded` コールバック内で `MediaContent` オブジェクトから動画の再生時間やアスペクト比をすぐに照会すると、`0.0` が返されます。これらの値は、広告ビューがインフレートされてレイアウトされた後、つまり `render_template()` を呼び出した**後**に照会する必要があります。
