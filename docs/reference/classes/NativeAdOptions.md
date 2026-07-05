# NativeAdOptions

The `NativeAdOptions` class configures preferences for rendering native overlay ads.

## Properties

### `media_aspect_ratio` / `MediaAspectRatio`

The preferred aspect ratio for media content displayed within the native ad.

=== "GDScript"
    ```gdscript
    var media_aspect_ratio: NativeMediaAspectRatio.Values
    ```

=== "C#"
    ```csharp
    public NativeMediaAspectRatio MediaAspectRatio { get; set; }
    ```

### `ad_choices_placement` / `AdChoicesPlacement`

The preferred screen corner overlay placement for the AdChoices icon.

=== "GDScript"
    ```gdscript
    var ad_choices_placement: AdChoicesPlacement.Values
    ```

=== "C#"
    ```csharp
    public AdChoicesPlacement AdChoicesPlacement { get; set; }
    ```

### `video_options` / `VideoOptions`

The custom video configurations applied to any video elements inside the native ad.

=== "GDScript"
    ```gdscript
    var video_options: AdVideoOptions
    ```

=== "C#"
    ```csharp
    public AdVideoOptions VideoOptions { get; set; }
    ```
