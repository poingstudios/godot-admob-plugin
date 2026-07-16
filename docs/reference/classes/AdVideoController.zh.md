# AdVideoController

`AdVideoController` 类提供了查询原生广告内视频资产信息并设置回调以处理视频播放事件的方法。

## 属性

### `video_lifecycle_callbacks` / `VideoLifecycleCallbacks`

接收视频播放事件的 [`VideoLifecycleCallbacks`](../listeners/VideoLifecycleCallbacks.md) 实例。

=== "GDScript"
    ```gdscript
    var video_lifecycle_callbacks: VideoLifecycleCallbacks
    ```

=== "C#"
    ```csharp
    public VideoLifecycleCallbacks VideoLifecycleCallbacks { get; set; }
    ```

## 方法

### `is_muted` / `IsMuted`

如果视频当前处于静音状态，则返回 `true`。

=== "GDScript"
    ```gdscript
    func is_muted() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsMuted()
    ```

### `is_custom_controls_enabled` / `IsCustomControlsEnabled`

如果为此视频启用了自定义控制，则返回 `true`。

=== "GDScript"
    ```gdscript
    func is_custom_controls_enabled() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCustomControlsEnabled()
    ```
