# NativeAdOptions

`NativeAdOptions` クラスは、ネイティブオーバーレイ広告のレンダリング設定を構成します。

## プロパティ

### `media_aspect_ratio` / `MediaAspectRatio`

ネイティブ広告内に表示されるメディアコンテンツの推奨アスペクト比。

=== "GDScript"
    ```gdscript
    var media_aspect_ratio: NativeMediaAspectRatio.Values
    ```

=== "C#"
    ```csharp
    public NativeMediaAspectRatio MediaAspectRatio { get; set; }
    ```

### `ad_choices_placement` / `AdChoicesPlacement`

AdChoices アイコンオーバーレイの推奨画面隅の配置。

=== "GDScript"
    ```gdscript
    var ad_choices_placement: AdChoicesPlacement.Values
    ```

=== "C#"
    ```csharp
    public AdChoicesPlacement AdChoicesPlacement { get; set; }
    ```

### `video_options` / `VideoOptions`

ネイティブ広告内のすべての動画要素に適用されるカスタム動画設定。

=== "GDScript"
    ```gdscript
    var video_options: AdVideoOptions
    ```

=== "C#"
    ```csharp
    public AdVideoOptions VideoOptions { get; set; }
    ```
