# VideoLifecycleCallbacks

`VideoLifecycleCallbacks` 类包含在原生广告内的视频播放生命周期中调用的回调（Actions/Callables）。

## 回调列表

### `on_video_start` / `OnVideoStart`

当视频开始播放时调用。

=== "GDScript"
    ```gdscript
    var on_video_start: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoStart { get; set; }
    ```

### `on_video_play` / `OnVideoPlay`

当视频播放或恢复时调用。

=== "GDScript"
    ```gdscript
    var on_video_play: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPlay { get; set; }
    ```

### `on_video_pause` / `OnVideoPause`

当视频暂停时调用。

=== "GDScript"
    ```gdscript
    var on_video_pause: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPause { get; set; }
    ```

### `on_video_end` / `OnVideoEnd`

当视频播放结束时调用。

=== "GDScript"
    ```gdscript
    var on_video_end: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoEnd { get; set; }
    ```

### `on_video_mute` / `OnVideoMute`

当视频静音或取消静音时调用。如果当前处于静音状态则传入 `true`，否则传入 `false`。

=== "GDScript"
    ```gdscript
    var on_video_mute: Callable # func(is_muted: bool)
    ```

=== "C#"
    ```csharp
    public Action<bool> OnVideoMute { get; set; }
    ```
