# VideoLifecycleCallbacks

`VideoLifecycleCallbacks` クラスは、ネイティブ広告内のビデオ再生ライフサイクル中に呼び出されるコールバック（Action/Callable）を保持します。

## コールバック

### `on_video_start` / `OnVideoStart`

ビデオの再生が開始されたときに呼び出されます。

=== "GDScript"
    ```gdscript
    var on_video_start: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoStart { get; set; }
    ```

### `on_video_play` / `OnVideoPlay`

ビデオが再生または再開されたときに呼び出されます。

=== "GDScript"
    ```gdscript
    var on_video_play: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPlay { get; set; }
    ```

### `on_video_pause` / `OnVideoPause`

ビデオが一時停止されたときに呼び出されます。

=== "GDScript"
    ```gdscript
    var on_video_pause: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPause { get; set; }
    ```

### `on_video_end` / `OnVideoEnd`

ビデオの再生が終了したときに呼び出されます。

=== "GDScript"
    ```gdscript
    var on_video_end: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoEnd { get; set; }
    ```

### `on_video_mute` / `OnVideoMute`

ビデオがミュートまたはミュート解除されたときに呼び出されます。ビデオが現在ミュートされている場合は `true`、そうでない場合は `false` が渡されます。

=== "GDScript"
    ```gdscript
    var on_video_mute: Callable # func(is_muted: bool)
    ```

=== "C#"
    ```csharp
    public Action<bool> OnVideoMute { get; set; }
    ```
