# AdVideoOptions

`AdVideoOptions` 类配置在原生模板广告中加载的视频元素的播放行为。

## 属性

### `click_to_expand_requested` / `ClickToExpandRequested`

用户是否可以点击将视频内容扩展到全屏。

=== "GDScript"
    ```gdscript
    var click_to_expand_requested: bool
    ```

=== "C#"
    ```csharp
    public bool ClickToExpandRequested { get; set; }
    ```

### `custom_controls_requested` / `CustomControlsRequested`

是否为视频播放器请求自定义媒体控件。

=== "GDScript"
    ```gdscript
    var custom_controls_requested: bool
    ```

=== "C#"
    ```csharp
    public bool CustomControlsRequested { get; set; }
    ```

### `start_muted` / `StartMuted`

视频媒体元素是否应以静音状态开始播放。

=== "GDScript"
    ```gdscript
    var start_muted: bool
    ```

=== "C#"
    ```csharp
    public bool StartMuted { get; set; }
    ```
