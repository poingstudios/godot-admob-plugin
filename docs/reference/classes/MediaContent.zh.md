# MediaContent

`MediaContent` 类表示与原生广告关联的媒体资产（例如视频或图像）。

## 方法

### `has_video_content` / `HasVideoContent`

如果媒体内容包含视频资产，则返回 `true`。

=== "GDScript"
    ```gdscript
    func has_video_content() -> bool
    ```

=== "C#"
    ```csharp
    public bool HasVideoContent()
    ```

### `get_video_controller` / `GetVideoController`

返回与此媒体内容关联的 [`AdVideoController`](AdVideoController.zh.md)，以控制视频播放并接收视频事件。

=== "GDScript"
    ```gdscript
    func get_video_controller() -> AdVideoController
    ```

=== "C#"
    ```csharp
    public AdVideoController GetVideoController()
    ```

### `get_duration` / `GetDuration`

返回视频资产的长度（以秒为单位），如果没有视频内容则返回 `0.0`。

=== "GDScript"
    ```gdscript
    func get_duration() -> float
    ```

=== "C#"
    ```csharp
    public float GetDuration()
    ```

### `get_aspect_ratio` / `GetAspectRatio`

返回媒体内容的宽高比（宽/高），如果不可用则返回 `0.0`。

=== "GDScript"
    ```gdscript
    func get_aspect_ratio() -> float
    ```

=== "C#"
    ```csharp
    public float GetAspectRatio()
    ```
