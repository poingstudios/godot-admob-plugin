# NativeAdOptions

`NativeAdOptions` 类配置原生叠加广告的渲染偏好。

## 属性

### `media_aspect_ratio` / `MediaAspectRatio`

原生广告内显示的媒体内容的首选宽高比。

=== "GDScript"
    ```gdscript
    var media_aspect_ratio: NativeMediaAspectRatio.Values
    ```

=== "C#"
    ```csharp
    public NativeMediaAspectRatio MediaAspectRatio { get; set; }
    ```

### `ad_choices_placement` / `AdChoicesPlacement`

AdChoices 图标叠加的首选屏幕角落位置。

=== "GDScript"
    ```gdscript
    var ad_choices_placement: AdChoicesPlacement.Values
    ```

=== "C#"
    ```csharp
    public AdChoicesPlacement AdChoicesPlacement { get; set; }
    ```

### `video_options` / `VideoOptions`

应用于原生广告内任何视频元素的自定义视频配置。

=== "GDScript"
    ```gdscript
    var video_options: AdVideoOptions
    ```

=== "C#"
    ```csharp
    public AdVideoOptions VideoOptions { get; set; }
    ```
