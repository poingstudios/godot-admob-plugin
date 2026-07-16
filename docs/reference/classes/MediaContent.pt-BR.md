# MediaContent

A classe `MediaContent` representa os recursos de mídia (ex: vídeo ou imagem) associados a um anúncio nativo.

## Métodos

### `has_video_content` / `HasVideoContent`

Retorna `true` se o conteúdo de mídia contiver um recurso de vídeo.

=== "GDScript"
    ```gdscript
    func has_video_content() -> bool
    ```

=== "C#"
    ```csharp
    public bool HasVideoContent()
    ```

### `get_video_controller` / `GetVideoController`

Retorna o [`AdVideoController`](AdVideoController.pt-BR.md) associado a este conteúdo de mídia para controlar a reprodução do vídeo e receber eventos do vídeo.

=== "GDScript"
    ```gdscript
    func get_video_controller() -> AdVideoController
    ```

=== "C#"
    ```csharp
    public AdVideoController GetVideoController()
    ```

### `get_duration` / `GetDuration`

Retorna a duração do recurso de vídeo em segundos, ou `0.0` se não houver conteúdo de vídeo.

=== "GDScript"
    ```gdscript
    func get_duration() -> float
    ```

=== "C#"
    ```csharp
    public float GetDuration()
    ```

### `get_aspect_ratio` / `GetAspectRatio`

Retorna a proporção (largura/altura) do conteúdo de mídia, ou `0.0` se não estiver disponível.

=== "GDScript"
    ```gdscript
    func get_aspect_ratio() -> float
    ```

=== "C#"
    ```csharp
    public float GetAspectRatio()
    ```
