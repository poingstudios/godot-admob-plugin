# VideoLifecycleCallbacks

The `VideoLifecycleCallbacks` class contains callbacks (actions/callables) invoked during a video's playback lifecycle inside a native ad.

## Callbacks

### `on_video_start` / `OnVideoStart`

Called when the video starts playing.

=== "GDScript"
    ```gdscript
    var on_video_start: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoStart { get; set; }
    ```

### `on_video_play` / `OnVideoPlay`

Called when the video is played/resumed.

=== "GDScript"
    ```gdscript
    var on_video_play: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPlay { get; set; }
    ```

### `on_video_pause` / `OnVideoPause`

Called when the video is paused.

=== "GDScript"
    ```gdscript
    var on_video_pause: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPause { get; set; }
    ```

### `on_video_end` / `OnVideoEnd`

Called when the video finishes playing.

=== "GDScript"
    ```gdscript
    var on_video_end: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoEnd { get; set; }
    ```

### `on_video_mute` / `OnVideoMute`

Called when the video is muted or unmuted. Passes `true` if the video is now muted, `false` otherwise.

=== "GDScript"
    ```gdscript
    var on_video_mute: Callable # func(is_muted: bool)
    ```

=== "C#"
    ```csharp
    public Action<bool> OnVideoMute { get; set; }
    ```
