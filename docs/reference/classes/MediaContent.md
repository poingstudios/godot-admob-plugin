# MediaContent

The `MediaContent` class represents the media assets (e.g., video or image) associated with a native ad.

## Methods

### `has_video_content` / `HasVideoContent`

Returns `true` if the media content contains a video asset.

=== "GDScript"
    ```gdscript
    func has_video_content() -> bool
    ```

=== "C#"
    ```csharp
    public bool HasVideoContent()
    ```

### `get_video_controller` / `GetVideoController`

Returns the [`AdVideoController`](AdVideoController.md) associated with this media content to control video playback and receive video events.

=== "GDScript"
    ```gdscript
    func get_video_controller() -> AdVideoController
    ```

=== "C#"
    ```csharp
    public AdVideoController GetVideoController()
    ```

### `get_duration` / `GetDuration`

Returns the duration of the video asset in seconds, or `0.0` if there is no video content.

=== "GDScript"
    ```gdscript
    func get_duration() -> float
    ```

=== "C#"
    ```csharp
    public float GetDuration()
    ```

### `get_aspect_ratio` / `GetAspectRatio`

Returns the aspect ratio (width/height) of the media content, or `0.0` if not available.

=== "GDScript"
    ```gdscript
    func get_aspect_ratio() -> float
    ```

=== "C#"
    ```csharp
    public float GetAspectRatio()
    ```
