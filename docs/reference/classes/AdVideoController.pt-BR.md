# AdVideoController

A classe `AdVideoController` fornece métodos para consultar informações sobre um recurso de vídeo dentro de um anúncio nativo e configurar callbacks para manipular eventos de reprodução de vídeo.

## Propriedades

### `video_lifecycle_callbacks` / `VideoLifecycleCallbacks`

Uma instância de [`VideoLifecycleCallbacks`](../listeners/VideoLifecycleCallbacks.md) que recebe eventos de reprodução do vídeo.

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

Retorna `true` se o vídeo estiver mutado no momento.

=== "GDScript"
    ```gdscript
    func is_muted() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsMuted()
    ```

### `is_custom_controls_enabled` / `IsCustomControlsEnabled`

Retorna `true` se os controles personalizados estiverem habilitados para este vídeo.

=== "GDScript"
    ```gdscript
    func is_custom_controls_enabled() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCustomControlsEnabled()
    ```
