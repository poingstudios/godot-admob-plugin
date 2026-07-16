# AdVideoController

The `AdVideoController` class provides methods to query information about a video asset inside a native ad and set callbacks to handle video playback events.

## Properties

### `video_lifecycle_callbacks` / `VideoLifecycleCallbacks`

A [`VideoLifecycleCallbacks`](../listeners/VideoLifecycleCallbacks.md) instance that receives video playback events.

=== "GDScript"
    ```gdscript
    var video_lifecycle_callbacks: VideoLifecycleCallbacks
    ```

=== "C#"
    ```csharp
    public VideoLifecycleCallbacks VideoLifecycleCallbacks { get; set; }
    ```

## Methods

### `is_muted` / `IsMuted`

Returns `true` if the video is currently muted.

=== "GDScript"
    ```gdscript
    func is_muted() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsMuted()
    ```

### `is_custom_controls_enabled` / `IsCustomControlsEnabled`

Returns `true` if custom controls are enabled for this video.

=== "GDScript"
    ```gdscript
    func is_custom_controls_enabled() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCustomControlsEnabled()
    ```
