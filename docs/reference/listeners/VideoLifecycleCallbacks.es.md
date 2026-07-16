# VideoLifecycleCallbacks

La clase `VideoLifecycleCallbacks` contiene callbacks (acciones/callables) invocados durante el ciclo de vida de reproducción de un video dentro de un anuncio nativo.

## Callbacks

### `on_video_start` / `OnVideoStart`

Se llama cuando el video comienza a reproducirse.

=== "GDScript"
    ```gdscript
    var on_video_start: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoStart { get; set; }
    ```

### `on_video_play` / `OnVideoPlay`

Se llama cuando el video se reproduce o se reanuda.

=== "GDScript"
    ```gdscript
    var on_video_play: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPlay { get; set; }
    ```

### `on_video_pause` / `OnVideoPause`

Se llama cuando el video se pausa.

=== "GDScript"
    ```gdscript
    var on_video_pause: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPause { get; set; }
    ```

### `on_video_end` / `OnVideoEnd`

Se llama cuando el video termina de reproducirse.

=== "GDScript"
    ```gdscript
    var on_video_end: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoEnd { get; set; }
    ```

### `on_video_mute` / `OnVideoMute`

Se llama cuando el video se silencia o se activa el sonido. Pasa `true` si el video ahora está silenciado, `false` en caso contrario.

=== "GDScript"
    ```gdscript
    var on_video_mute: Callable # func(is_muted: bool)
    ```

=== "C#"
    ```csharp
    public Action<bool> OnVideoMute { get; set; }
    ```
