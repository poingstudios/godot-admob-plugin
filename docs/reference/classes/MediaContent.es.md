# MediaContent

La clase `MediaContent` representa los recursos multimedia (por ejemplo, video o imagen) asociados con un anuncio nativo.

## Métodos

### `has_video_content` / `HasVideoContent`

Devuelve `true` si el contenido multimedia contiene un recurso de video.

=== "GDScript"
    ```gdscript
    func has_video_content() -> bool
    ```

=== "C#"
    ```csharp
    public bool HasVideoContent()
    ```

### `get_video_controller` / `GetVideoController`

Devuelve el [`AdVideoController`](AdVideoController.es.md) asociado con este contenido multimedia para controlar la reproducción de video y recibir eventos de video.

=== "GDScript"
    ```gdscript
    func get_video_controller() -> AdVideoController
    ```

=== "C#"
    ```csharp
    public AdVideoController GetVideoController()
    ```

### `get_duration` / `GetDuration`

Devuelve la duración del recurso de video en segundos, o `0.0` si no hay contenido de video.

=== "GDScript"
    ```gdscript
    func get_duration() -> float
    ```

=== "C#"
    ```csharp
    public float GetDuration()
    ```

### `get_aspect_ratio` / `GetAspectRatio`

Devuelve la relación de aspecto (ancho/alto) del contenido multimedia, o `0.0` si no está disponible.

=== "GDScript"
    ```gdscript
    func get_aspect_ratio() -> float
    ```

=== "C#"
    ```csharp
    public float GetAspectRatio()
    ```
