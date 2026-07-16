# VideoLifecycleCallbacks

A classe `VideoLifecycleCallbacks` contém callbacks (ações/callables) invocados durante o ciclo de vida de reprodução de um vídeo dentro de um anúncio nativo.

## Callbacks

### `on_video_start` / `OnVideoStart`

Chamado quando o vídeo começa a ser reproduzido.

=== "GDScript"
    ```gdscript
    var on_video_start: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoStart { get; set; }
    ```

### `on_video_play` / `OnVideoPlay`

Chamado quando o vídeo é reproduzido/retomado.

=== "GDScript"
    ```gdscript
    var on_video_play: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPlay { get; set; }
    ```

### `on_video_pause` / `OnVideoPause`

Chamado quando o vídeo é pausado.

=== "GDScript"
    ```gdscript
    var on_video_pause: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoPause { get; set; }
    ```

### `on_video_end` / `OnVideoEnd`

Chamado quando o vídeo termina de ser reproduzido.

=== "GDScript"
    ```gdscript
    var on_video_end: Callable
    ```

=== "C#"
    ```csharp
    public Action OnVideoEnd { get; set; }
    ```

### `on_video_mute` / `OnVideoMute`

Chamado quando o vídeo é silenciado ou reativado o som. Passa `true` se o vídeo estiver silenciado agora, ou `false` caso contrário.

=== "GDScript"
    ```gdscript
    var on_video_mute: Callable # func(is_muted: bool)
    ```

=== "C#"
    ```csharp
    public Action<bool> OnVideoMute { get; set; }
    ```
