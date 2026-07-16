# AdVideoController

La clase `AdVideoController` proporciona métodos para consultar información sobre un recurso de video dentro de un anuncio nativo y configurar callbacks para manejar eventos de reproducción de video.

## Propiedades

### `video_lifecycle_callbacks` / `VideoLifecycleCallbacks`

Una instancia de [`VideoLifecycleCallbacks`](../listeners/VideoLifecycleCallbacks.md) que recibe eventos de reproducción de video.

=== "GDScript"
    ```gdscript
    var video_lifecycle_callbacks: VideoLifecycleCallbacks
    ```

=== "C#"
    ```csharp
    public VideoLifecycleCallbacks VideoLifecycleCallbacks { get; set; }
    ```

## Métodos

### `is_muted` / `IsMuted`

Devuelve `true` si el video está silenciado actualmente.

=== "GDScript"
    ```gdscript
    func is_muted() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsMuted()
    ```

### `is_custom_controls_enabled` / `IsCustomControlsEnabled`

Devuelve `true` si los controles personalizados están habilitados para este video.

=== "GDScript"
    ```gdscript
    func is_custom_controls_enabled() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCustomControlsEnabled()
    ```
